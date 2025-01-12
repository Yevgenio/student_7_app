# ProGuard rules for your app
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
