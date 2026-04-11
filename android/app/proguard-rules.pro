# ProxDroid — R8 / ProGuard (Flutter release). See:
# https://docs.flutter.dev/deployment/android#enabling-r8-full-mode

# Flutter embedding
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Play Core — optional deferred-components / dynamic feature APIs referenced by the
# Flutter Android embedding. The Play Core artifacts are not an app dependency;
# without -dontwarn, R8 fails release minify with "Missing class … play.core …".
-dontwarn com.google.android.play.core.**
