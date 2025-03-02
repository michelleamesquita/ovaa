#!/bin/bash

# Caminho correto da MainActivity no Ovaa
MAIN_ACTIVITY="app/src/main/java/oversecured/ovaa/activities/MainActivity.java"

# Verifica se o arquivo existe antes de modificar
if [ -f "$MAIN_ACTIVITY" ]; then
    echo "Modificando MainActivity.java para incluir RASP..."

    # Adiciona importações do Android RASP e Toast
    sed -i '/import android.os.Bundle;/a \
    import com.securevale.rasp.android.api.SecureAppChecker;\n\
    import com.securevale.rasp.android.api.result.Result;\n\
    import android.widget.Toast;' $MAIN_ACTIVITY

    # Adiciona inicialização do SecureApp dentro do onCreate
    sed -i '/setContentView(R.layout.activity_main);/a \
        \n        SecureApp.init();\n\
        \n        boolean shouldCheckForEmulator = true;\n\
        boolean shouldCheckForDebugger = true;\n\
        boolean shouldCheckForRoot = true;\n\
        \n        SecureAppChecker.Builder builder = new SecureAppChecker.Builder(\n\
            this, shouldCheckForEmulator, shouldCheckForDebugger, shouldCheckForRoot\n\
        );\n\
        \n        SecureAppChecker check = builder.build();\n\
        Result checkResult = check.check();\n\
        \n        if (checkResult instanceof Result.EmulatorFound) {\n\
            Toast.makeText(this, \"App está rodando em um emulador!\", Toast.LENGTH_LONG).show();\n\
            finish();\n\
        } else if (checkResult instanceof Result.DebuggerEnabled) {\n\
            Toast.makeText(this, \"App está em modo de depuração!\", Toast.LENGTH_LONG).show();\n\
            finish();\n\
        } else if (checkResult instanceof Result.Rooted) {\n\
            Toast.makeText(this, \"Dispositivo rooteado!\", Toast.LENGTH_LONG).show();\n\
            finish();\n\
        }' $MAIN_ACTIVITY

    echo "MainActivity.java atualizado com sucesso!"
else
    echo "Erro: MainActivity.java não encontrado!"
    exit 1
fi
