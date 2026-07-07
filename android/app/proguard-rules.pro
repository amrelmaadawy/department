# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-dontwarn io.flutter.embedding.**

# FlutterSecureStorage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Do not strip annotations
-keepattributes *Annotation*

# Do not strip exception info
-keepattributes Exceptions, InnerClasses

# Gson / Serialization code
-keepattributes Signature
-keep class com.google.gson.** { *; }

# Keep all Data Models (JSON Parsing)
-keep class com.codra.shatabha.** { *; }
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# local_auth (Biometric)
-keep class io.flutter.plugins.localauth.** { *; }

# Dio & OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }

# Keep Enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# ── flutter_native_html_to_pdf (WebView-based HTML→PDF) ────────────────────
# The plugin uses Android WebView internally to render HTML and convert to PDF.
# R8 strips these classes in release builds, causing crashes on real devices.
-keep class android.webkit.** { *; }
-keep class android.print.** { *; }
-dontwarn android.webkit.**
-dontwarn android.print.**
