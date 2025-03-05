#!/bin/bash

# Caminho correto do arquivo MainActivity no projeto
MAIN_ACTIVITY="app/src/main/java/oversecured/ovaa/activities/MainActivity.java"

# Verifica se o arquivo MainActivity.java existe antes de modificar
if [ ! -f "$MAIN_ACTIVITY" ]; then
    echo "❌ ERRO: MainActivity.java não encontrado!"
    exit 1
fi

echo "🛡️ Adicionando segurança ao MainActivity.java..."

# 🔹 Adiciona importações necessárias (caso ainda não existam)
if ! grep -q "import android.os.Debug;" "$MAIN_ACTIVITY"; then
    sed -i '/import android.os.Bundle;/a \
    import android.os.Debug;\n\
    import java.io.BufferedReader;\n\
    import java.io.File;\n\
    import java.io.InputStreamReader;' "$MAIN_ACTIVITY"
    echo "✅ Importações adicionadas!"
else
    echo "⚠️ Importações já existem, ignorando..."
fi

# 🔹 Adiciona a verificação de Debug dentro do onCreate()
if ! grep -q "if (isDebugged())" "$MAIN_ACTIVITY"; then
    sed -i '/setContentView(R.layout.activity_main);/a \
        \n        if (isDebugged()) {\n\
            Log.d("SECURITY_CHECK", "⚠️ Debugger detectado! Fechando app...");\n\
            finish();\n\
        }\n\
        if (isDeviceRooted()) {\n\
            Log.d("SECURITY_CHECK", "🔴 Dispositivo rooteado detectado!");\n\
            finish();\n\
        }' "$MAIN_ACTIVITY"
    echo "✅ Verificação de Debug e Root adicionada no onCreate()!"
else
    echo "⚠️ Verificação de Debug e Root já existe, ignorando..."
fi

# 🔹 Adiciona o método de detecção de Debug (caso ainda não exista)
if ! grep -q "private boolean isDebugged()" "$MAIN_ACTIVITY"; then
    sed -i '/public class MainActivity extends AppCompatActivity {/a \
    \n    private boolean isDebugged() {\n\
        return Debug.isDebuggerConnected();\n\
    }' "$MAIN_ACTIVITY"
    echo "✅ Método isDebugged() adicionado!"
else
    echo "⚠️ Método isDebugged() já existe, ignorando..."
fi

# 🔹 Adiciona o método de detecção de Root (caso ainda não exista)
if ! grep -q "private boolean isDeviceRooted()" "$MAIN_ACTIVITY"; then
    sed -i '/public class MainActivity extends AppCompatActivity {/a \
    \n    private boolean isDeviceRooted() {\n\
        String[] paths = {\n\
            "/system/bin/su", "/system/xbin/su", "/system/app/Superuser.apk", "/system/app/SuperSU.apk", "/system/xbin/daemonsu"\n\
        };\n\
        for (String path : paths) {\n\
            if (new File(path).exists()) {\n\
                return true;\n\
            }\n\
        }\n\
        try {\n\
            Process process = Runtime.getRuntime().exec(new String[]{"/system/xbin/which", "su"});\n\
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));\n\
            if (in.readLine() != null) return true;\n\
        } catch (Exception e) {\n\
            return false;\n\
        }\n\
        return false;\n\
    }' "$MAIN_ACTIVITY"
    echo "✅ Método isDeviceRooted() adicionado!"
else
    echo "⚠️ Método isDeviceRooted() já existe, ignorando..."
fi

echo "🔒 Segurança adicionada com sucesso ao MainActivity.java!"
