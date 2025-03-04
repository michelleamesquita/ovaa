package oversecured.ovaa.activities;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

import oversecured.ovaa.R;
import oversecured.ovaa.objects.LoginData;
import oversecured.ovaa.utils.FileUtils;
import oversecured.ovaa.utils.IntentUtils;
import oversecured.ovaa.utils.LoginUtils;
import oversecured.ovaa.utils.WeakCrypto;
import oversecured.ovaa.utils.ProGuardCheck;

public class MainActivity extends AppCompatActivity {
    private static final int PICK_CODE = 1001;
    private static final int PERMISSIONS_CODE = 1002;

    private LoginUtils loginUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        loginUtils = LoginUtils.getInstance(this);

        // Verificação de Root
        checkRoot();

        // Verificação de Debug
        checkDebug();

        // Verificação do ProGuard
        checkProGuard();

        findViewById(R.id.fileTheftButton).setOnClickListener(view -> {
            checkPermissions();
            Intent pickerIntent = new Intent(Intent.ACTION_PICK);
            pickerIntent.setType("image/*");
            startActivityForResult(pickerIntent, PICK_CODE);
        });

        findViewById(R.id.broadcastButton).setOnClickListener(view -> {
            Intent i = new Intent("oversecured.ovaa.action.UNPROTECTED_CREDENTIALS_DATA");
            i.putExtra("payload", MainActivity.this.loginUtils.getLoginData());
            sendBroadcast(i);
        });

        findViewById(R.id.activityButton).setOnClickListener(view -> {
            LoginData loginData = MainActivity.this.loginUtils.getLoginData();
            String token = WeakCrypto.encrypt(loginData.toString());
            Intent i = new Intent("oversecured.ovaa.action.WEBVIEW");
            i.putExtra("url", "http://example.com./?token=" + token);
            IntentUtils.protectActivityIntent(MainActivity.this, i);
            startActivity(i);
        });
    }

    // 🚨 Verificação de Root
    private void checkRoot() {
        if (isDeviceRooted()) {
            Log.d("ROOT_CHECK", "🔴 Dispositivo está rooteado!");
            Toast.makeText(this, "Dispositivo rooteado!", Toast.LENGTH_LONG).show();
            finish(); // Fecha o app se estiver rootado
        } else {
            Log.d("ROOT_CHECK", "✅ Dispositivo não está rooteado!");
        }
    }

    private boolean isDeviceRooted() {
        String[] paths = {
                "/system/bin/su", "/system/xbin/su", "/system/app/Superuser.apk",
                "/system/app/SuperSU.apk", "/system/xbin/daemonsu"
        };

        for (String path : paths) {
            if (new File(path).exists()) {
                return true;
            }
        }

        try {
            Process process = Runtime.getRuntime().exec(new String[]{"/system/xbin/which", "su"});
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            if (in.readLine() != null) return true;
        } catch (Exception e) {
            return false;
        }

        return false;
    }

    // 🚨 Verificação de Debug
    private void checkDebug() {
        if (BuildConfig.DEBUG) {
            Log.d("DEBUG_CHECK", "⚠️ O app está rodando em modo DEBUG!");
            Toast.makeText(this, "O app está rodando em modo DEBUG!", Toast.LENGTH_LONG).show();
        } else {
            Log.d("DEBUG_CHECK", "✅ O app está rodando em modo RELEASE!");
        }
    }

    // 🚨 Verificação do ProGuard
    private void checkProGuard() {
        try {
            String className = ProGuardCheck.class.getName();
            String methodName = ProGuardCheck.class.getDeclaredMethod("testMethod").getName();

            Log.d("PROGUARD_CHECK", "Classe: " + className);
            Log.d("PROGUARD_CHECK", "Método: " + methodName);

            if (!className.equals("oversecured.ovaa.utils.ProGuardCheck") || 
                !methodName.equals("testMethod")) {
                Log.d("PROGUARD_CHECK", "⚠️ ProGuard está ativo! Código foi ofuscado.");
                Toast.makeText(this, "ProGuard está ativo!", Toast.LENGTH_LONG).show();
            } else {
                Log.d("PROGUARD_CHECK", "✅ ProGuard não está ativo!");
            }
        } catch (Exception e) {
            Log.e("PROGUARD_CHECK", "Erro ao verificar ProGuard", e);
        }
    }

    private void checkPermissions() {
        String[] permissions = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE};
        for(String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, permissions, PERMISSIONS_CODE);
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == -1 && data != null) {
            if (requestCode == PICK_CODE) {
                FileUtils.copyToCache(this, data.getData());
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSIONS_CODE) {
            for (int grantResult : grantResults) {
                if (grantResult != PackageManager.PERMISSION_GRANTED) {
                    checkPermissions();
                }
            }
        }
    }
}
