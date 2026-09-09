import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("local.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

fun propOrEnv(propertyKey: String, envKey: String): String {
    val fromProps = keystoreProperties.getProperty(propertyKey)?.trim().orEmpty()
    if (fromProps.isNotEmpty()) return fromProps
    return System.getenv(envKey)?.trim().orEmpty()
}

val tiktokAppId = propOrEnv("tiktok.app.id", "TIKTOK_APP_ID").ifEmpty { "com.rnr.deenfocus" }
val tiktokTtAppId = propOrEnv("tiktok.tt.app.id", "TIKTOK_TT_APP_ID")
val tiktokAppSecret = propOrEnv("tiktok.app.secret", "TIKTOK_APP_SECRET")

val metaAppId = propOrEnv("meta.app.id", "META_APP_ID")
val metaClientToken = propOrEnv("meta.client.token", "META_CLIENT_TOKEN")
val metaDisplayName = propOrEnv("meta.display.name", "META_DISPLAY_NAME").ifEmpty { "Deen Focus" }

android {
    namespace = "com.rnr.deenfocus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.rnr.deenfocus"
        // superwallkit_flutter / Superwall Android SDK requires minSdk 26.
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true

        // TikTok credentials — never hardcode secrets in source. Provide via
        // android/local.properties or CI env vars (see TikTokAppEventsService docs).
        buildConfigField("String", "TIKTOK_APP_ID", "\"${tiktokAppId.replace("\"", "\\\"")}\"")
        buildConfigField("String", "TIKTOK_TT_APP_ID", "\"${tiktokTtAppId.replace("\"", "\\\"")}\"")
        buildConfigField("String", "TIKTOK_APP_SECRET", "\"${tiktokAppSecret.replace("\"", "\\\"")}\"")
        buildConfigField("String", "META_APP_ID", "\"${metaAppId.replace("\"", "\\\"")}\"")
        buildConfigField("String", "META_CLIENT_TOKEN", "\"${metaClientToken.replace("\"", "\\\"")}\"")
        buildConfigField("String", "META_DISPLAY_NAME", "\"${metaDisplayName.replace("\"", "\\\"")}\"")

        // Manifest placeholders for Meta meta-data (empty until credentials are provided).
        manifestPlaceholders["facebookAppId"] = metaAppId
        manifestPlaceholders["facebookClientToken"] = metaClientToken
        manifestPlaceholders["facebookDisplayName"] = metaDisplayName
        resValue("string", "facebook_app_id", metaAppId)
        resValue("string", "facebook_client_token", metaClientToken)
        resValue("string", "fb_login_protocol_scheme", if (metaAppId.isEmpty()) "" else "fb$metaAppId")
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-splashscreen:1.0.1")

    // Official TikTok App Events SDK (Android) — https://business-api.tiktok.com/portal/docs/android-integration-steps/v1.3
    implementation("com.github.tiktok:tiktok-business-android-sdk:1.7.1")
    implementation("androidx.lifecycle:lifecycle-process:2.8.7")
    implementation("androidx.lifecycle:lifecycle-common-java8:2.8.7")
    // Required by TikTok SDK docs for optional auto IAP / Play Billing helpers.
    implementation("com.android.billingclient:billing:7.1.1")
    implementation("com.android.installreferrer:installreferrer:2.2")

    // Official Meta / Facebook App Events SDK (Android).
    // https://developers.facebook.com/docs/app-events/getting-started-app-events-android/
    implementation("com.facebook.android:facebook-core:18.0.3")
}

flutter {
    source = "../.."
}
