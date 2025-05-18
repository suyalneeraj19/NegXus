-keep class **.zego.** { *; }

# Prevent R8 from removing this class and its members
-keep class com.itgsa.opensdk.mediaunit.KaraokeMediaHelper { *; }
-keep class com.itgsa.opensdk.media.** { *; }

# Jackson-specific rules for missing JavaBeans classes
-keep class java.beans.** { *; }
-dontwarn java.beans.**

# DOM-related missing classes
-keep class org.w3c.dom.bootstrap.** { *; }
-dontwarn org.w3c.dom.bootstrap.**

# Jackson (if you use it)
-keep class com.fasterxml.jackson.databind.** { *; }
-dontwarn com.fasterxml.jackson.databind.**
