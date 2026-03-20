package com.app.deenly.deenly

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val focusMethodChannelName = "com.app.deenly.deenly/focus"
    private val qiblaMethodChannelName = "com.app.deenly.deenly/qibla_compass_method"
    private val qiblaEventChannelName = "com.app.deenly.deenly/qibla_compass_events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val headingStreamHandler = QiblaHeadingStreamHandler(
            sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager,
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            focusMethodChannelName,
        ).setMethodCallHandler { call, result ->
            handleFocusMethodCall(call, result)
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            qiblaMethodChannelName,
        ).setMethodCallHandler { call, result ->
            handleQiblaMethodCall(call, result, headingStreamHandler)
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            qiblaEventChannelName,
        ).setStreamHandler(headingStreamHandler)
    }

    private fun handleFocusMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "getInstalledApps" -> {
                Thread {
                    runCatching { getInstalledApps() }
                        .onSuccess { apps ->
                            runOnUiThread { result.success(apps) }
                        }
                        .onFailure { error ->
                            runOnUiThread {
                                result.error(
                                    "GET_APPS_FAILED",
                                    error.message ?: "Unable to load installed apps.",
                                    null,
                                )
                            }
                        }
                }.start()
            }
            "syncFocusState" -> {
                val selectedPackages =
                    call.argument<List<String>>("selectedPackages").orEmpty()
                val activeMode = call.argument<String>("activeMode")
                val isLocked = call.argument<Boolean>("isLocked") ?: false
                val lockReason = call.argument<String>("lockReason")
                val nextChangeAt = call.argument<String>("nextChangeAt")
                FocusBlockerStore.save(
                    context = applicationContext,
                    selectedPackages = selectedPackages,
                    activeMode = activeMode,
                    isLocked = isLocked,
                    lockReason = lockReason,
                    nextChangeAt = nextChangeAt,
                )
                result.success(null)
            }
            "isBlockingPermissionGranted" ->
                result.success(isFocusAccessibilityServiceEnabled(applicationContext))
            "openBlockingPermissionSettings" -> {
                openFocusAccessibilitySettings(applicationContext)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleQiblaMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
        headingStreamHandler: QiblaHeadingStreamHandler,
    ) {
        when (call.method) {
            "setLocation" -> {
                val latitude = call.argument<Double>("latitude")
                val longitude = call.argument<Double>("longitude")
                if (latitude == null || longitude == null) {
                    result.error("INVALID_LOCATION", "Latitude/longitude missing.", null)
                    return
                }
                headingStreamHandler.setLocation(latitude, longitude)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun getInstalledApps(): List<Map<String, Any>> {
        val packageManager = applicationContext.packageManager
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        return packages
            .asSequence()
            .filter { appInfo ->
                val packageName = appInfo.packageName
                packageName != applicationContext.packageName &&
                    packageManager.getLaunchIntentForPackage(packageName) != null
            }
            .map { appInfo ->
                mapOf(
                    "packageName" to appInfo.packageName,
                    "appName" to packageManager.getApplicationLabel(appInfo).toString(),
                    "isSystemApp" to appInfo.isSystemPackage(),
                    "iconBytes" to drawableToPngBytes(
                        packageManager.getApplicationIcon(appInfo.packageName),
                    ),
                )
            }
            .sortedBy { (it["appName"] as String).lowercase() }
            .toList()
    }
}

private fun ApplicationInfo.isSystemPackage(): Boolean {
    val systemFlags = ApplicationInfo.FLAG_SYSTEM or ApplicationInfo.FLAG_UPDATED_SYSTEM_APP
    return (flags and systemFlags) != 0
}

private class QiblaHeadingStreamHandler(
    private val sensorManager: SensorManager,
) : EventChannel.StreamHandler, SensorEventListener {
    private var eventSink: EventChannel.EventSink? = null
    private val rotationVectorSensor: Sensor? =
        sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
    private val accelerometerSensor: Sensor? =
        sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    private val magneticFieldSensor: Sensor? =
        sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

    private var latestAccelerometer: FloatArray? = null
    private var latestMagnetometer: FloatArray? = null
    private var latitude: Double? = null
    private var longitude: Double? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events

        if (rotationVectorSensor != null) {
            sensorManager.registerListener(
                this,
                rotationVectorSensor,
                SensorManager.SENSOR_DELAY_UI,
            )
            return
        }

        if (accelerometerSensor == null || magneticFieldSensor == null) {
            events.endOfStream()
            return
        }

        sensorManager.registerListener(
            this,
            accelerometerSensor,
            SensorManager.SENSOR_DELAY_UI,
        )
        sensorManager.registerListener(
            this,
            magneticFieldSensor,
            SensorManager.SENSOR_DELAY_UI,
        )
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        eventSink = null
    }

    fun setLocation(latitude: Double, longitude: Double) {
        this.latitude = latitude
        this.longitude = longitude
    }

    override fun onSensorChanged(event: SensorEvent) {
        when (event.sensor.type) {
            Sensor.TYPE_ROTATION_VECTOR -> emitHeadingFromRotationVector(event.values.clone())
            Sensor.TYPE_ACCELEROMETER -> latestAccelerometer = event.values.clone()
            Sensor.TYPE_MAGNETIC_FIELD -> latestMagnetometer = event.values.clone()
        }

        if (rotationVectorSensor == null) {
            emitHeadingFromSensorFusion()
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit

    private fun emitHeadingFromRotationVector(values: FloatArray) {
        val rotationMatrix = FloatArray(9)
        SensorManager.getRotationMatrixFromVector(rotationMatrix, values)
        emitHeading(rotationMatrix)
    }

    private fun emitHeadingFromSensorFusion() {
        val accelerometer = latestAccelerometer ?: return
        val magnetometer = latestMagnetometer ?: return
        val rotationMatrix = FloatArray(9)

        val success = SensorManager.getRotationMatrix(
            rotationMatrix,
            null,
            accelerometer,
            magnetometer,
        )

        if (success) emitHeading(rotationMatrix)
    }

    private fun emitHeading(rotationMatrix: FloatArray) {
        val orientation = FloatArray(3)
        SensorManager.getOrientation(rotationMatrix, orientation)
        var heading = Math.toDegrees(orientation[0].toDouble()).toFloat()

        val currentLatitude = latitude
        val currentLongitude = longitude
        if (currentLatitude != null && currentLongitude != null) {
            val geomagneticField = GeomagneticField(
                currentLatitude.toFloat(),
                currentLongitude.toFloat(),
                0f,
                System.currentTimeMillis(),
            )
            heading += geomagneticField.declination
        }

        eventSink?.success(normalizeHeading(heading))
    }

    private fun normalizeHeading(value: Float): Double {
        val normalized = ((value % 360f) + 360f) % 360f
        return normalized.toDouble()
    }
}
