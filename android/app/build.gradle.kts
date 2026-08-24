import java.util.Base64
import java.util.Properties
import java.io.FileInputStream
import java.nio.charset.StandardCharsets

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

/**
 * iOS gets dart_defines.json via tool/apply_dart_defines.sh → DartDefines.xcconfig.
 * Android must merge the same file into Flutter's `dart-defines`: Flutter CLI always
 * passes -Pdart-defines with FLUTTER_* entries even when --dart-define-from-file is
 * omitted, so String.fromEnvironment(SUPERWALL_API_KEY_*) is empty unless we merge.
 */
fun decodeDartDefines(encoded: String?): MutableMap<String, String> {
    val out = linkedMapOf<String, String>()
    if (encoded.isNullOrBlank()) return out
    for (part in encoded.split(',')) {
        if (part.isBlank()) continue
        val decoded = try {
            String(Base64.getDecoder().decode(part.trim()), StandardCharsets.UTF_8)
        } catch (_: IllegalArgumentException) {
            continue
        }
        val idx = decoded.indexOf('=')
        if (idx <= 0) continue
        out[decoded.substring(0, idx)] = decoded.substring(idx + 1)
    }
    return out
}

fun encodeDartDefines(map: Map<String, String>): String {
    return map.entries.joinToString(",") { (key, value) ->
        Base64.getEncoder().encodeToString(
            "$key=$value".toByteArray(StandardCharsets.UTF_8),
        )
    }
}

@Suppress("UNCHECKED_CAST")
fun loadRepoDartDefinesJson(): Map<String, String> {
    val file = rootProject.file("../dart_defines.json")
    if (!file.isFile) return emptyMap()
    val parsed = groovy.json.JsonSlurper().parse(file) as? Map<*, *> ?: return emptyMap()
    val out = linkedMapOf<String, String>()
    for ((rawKey, rawValue) in parsed) {
        val key = rawKey?.toString() ?: continue
        out[key] = rawValue?.toString().orEmpty()
    }
    return out
}

fun mergeDartDefines(existingEncoded: String?, fromFile: Map<String, String>): String {
    // File first, then overlay existing non-empty CLI/Flutter values so
    // --dart-define-from-file and FLUTTER_* still win when set.
    val merged = linkedMapOf<String, String>()
    merged.putAll(fromFile)
    for ((key, value) in decodeDartDefines(existingEncoded)) {
        if (value.isNotEmpty() || !merged.containsKey(key)) {
            merged[key] = value
        }
    }
    return encodeDartDefines(merged)
}

fun logDartDefinePresence(source: String, encoded: String) {
    val map = decodeDartDefines(encoded)
    val androidKey = "SUPERWALL_API_KEY_ANDROID"
    val androidValue = map[androidKey].orEmpty()
    logger.lifecycle(
        "[DeenFocus] $source define=$androidKey " +
            "keyPresent=${androidValue.isNotEmpty()} keyLength=${androidValue.length}",
    )
}

val repoDartDefines = loadRepoDartDefinesJson()
val incomingDartDefines = project.findProperty("dart-defines")?.toString()
val mergedDartDefines = mergeDartDefines(incomingDartDefines, repoDartDefines)
extra["dart-defines"] = mergedDartDefines
logDartDefinePresence("gradle merge", mergedDartDefines)

afterEvaluate {
    tasks.matching { it.name.startsWith("compileFlutterBuild") }.configureEach {
        val getter = javaClass.methods.firstOrNull {
            it.name == "getDartDefines" && it.parameterCount == 0
        }
        val setter = javaClass.methods.firstOrNull {
            it.name == "setDartDefines" && it.parameterCount == 1
        }
        if (getter == null || setter == null) {
            logger.warn(
                "[DeenFocus] ${name}: cannot patch dartDefines " +
                    "(get/setDartDefines missing)",
            )
            return@configureEach
        }
        val existing = getter.invoke(this) as String?
        val merged = mergeDartDefines(existing, repoDartDefines)
        setter.invoke(this, merged)
        logDartDefinePresence("${name} dartDefines", merged)
    }
}

android {
    namespace = "com.rnr.deenfocus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            isReturnDefaultValues = true
        }
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.rnr.deenfocus"
        // superwallkit_flutter / Superwall Android SDK requires minSdk 26.
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    // Release signing requires keystore properties in local.properties. Guard so that
    // debug builds (and CI/collaborators without a release keystore) don't crash at
    // Gradle configuration time — this ran unconditionally before and broke every
    // Gradle invocation, including `assembleDebug`, on a fresh checkout.
    val hasReleaseSigning = keystoreProperties.containsKey("storeFile")
    signingConfigs {
        // Only configure release signing when keystore props are present in
        // local.properties. Debug builds (and CI without a keystore) must not
        // fail just because release credentials are absent.
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        getByName("release") {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-splashscreen:1.0.1")
    // Compile against Superwall (same version as superwallkit_flutter 2.4.12).
    // Play Billing is owned internally by Superwall — do not add a second BillingClient.
    implementation("com.superwall.sdk:superwall-android:2.7.11")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
    // Tajweed (ADR-006/007): on-device ASR + pronunciation-head inference.
    implementation("com.microsoft.onnxruntime:onnxruntime-android:1.19.2")
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.robolectric:robolectric:4.14.1")
    testImplementation("androidx.test:core:1.6.1")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test:rules:1.6.1")
}

flutter {
    source = "../.."
}
