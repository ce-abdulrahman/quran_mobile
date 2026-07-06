# Isar database keep rules
-keep class io.isar.** { *; }
-keep class * extends io.isar.IsarObject { *; }
-dontwarn io.isar.**

# Keep our Isar model collections from being renamed or obfuscated by Proguard/R8
-keep class com.quran.mobile.quran_mobile.core.local_db.** { *; }

# Keep standard Flutter classes
-keep class io.flutter.plugin.** { *; }
