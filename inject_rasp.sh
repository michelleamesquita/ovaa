#!/bin/bash

# Caminho correto da MainActivity no Ovaa
MAIN_ACTIVITY="app/src/main/java/oversecured/ovaa/activities/MainActivity.java"

# Verifica se o arquivo existe antes de modificar
if [ -f "$MAIN_ACTIVITY" ]; then
    echo "Modificando MainActivity.java para incluir RASP..."

    # Adiciona importação do Android RASP
    sed -i '/import android.os.Bundle;/a import securevale.rasp.RASP;' $MAIN_ACTIVITY

    # Adiciona código dentro do onCreate para verificar root e emulador
    sed -i '/setContentView(R.layout.activity_main);/a \
        \n        // Inicializa o RASP\n        RASP rasp = new RASP(this);\n\
        if (rasp.isRooted()) {\n\
            Toast.makeText(this, "Dispositivo rooteado! Encerrando o app.", Toast.LENGTH_LONG).show();\n\
            finish();\n\
        }\n\
        if (rasp.isEmulator()) {\n\
            Toast.makeText(this, "Emulador detectado! Encerrando o app.", Toast.LENGTH_LONG).show();\n\
            finish();\n\
        }' $MAIN_ACTIVITY

    echo "MainActivity.java atualizado com sucesso!"
else
    echo "Erro: MainActivity.java não encontrado!"
    exit 1
fi
