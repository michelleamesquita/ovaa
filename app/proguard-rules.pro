# 🔥 Mantém as anotações do Android
-keepattributes *Annotation*

# 🚀 Mantém Activities, Services, Broadcasts e ContentProviders
-keep public class oversecured.ovaa.activities.** { *; }
-keep public class oversecured.ovaa.services.** { *; }
-keep public class oversecured.ovaa.receivers.** { *; }
-keep public class oversecured.ovaa.providers.** { *; }

# 🔍 Mantém os modelos de dados (Gson, Retrofit, Room, Jackson)
-keep class oversecured.ovaa.models.** { *; }

# ✅ Evita que ProGuard remova logs no Release
-assumenosideeffects class android.util.Log { *; }

# 🔄 Mantém Retrofit e Gson funcionando corretamente
-keep class retrofit2.** { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }
-keep class * implements com.google.gson.JsonSerializer { *; }
