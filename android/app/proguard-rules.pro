# TikTok App Events SDK (official consumer keep rules)
-keep class com.tiktok.** { *; }
-dontwarn com.tiktok.**

# Advertising ID (used when advertiser ID collection is enabled)
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}

# Google Play Billing / Install Referrer (TikTok IAP + attribution helpers)
-keep class com.android.vending.billing.** { *; }
-keep class com.android.billingclient.api.** { *; }
-keep interface com.android.billingclient.api.** { *; }
-keep class com.android.installreferrer.** { *; }

# Meta / Facebook App Events SDK
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**
