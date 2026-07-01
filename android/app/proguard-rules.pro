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
