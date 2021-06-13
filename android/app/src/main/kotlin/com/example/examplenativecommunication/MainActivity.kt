package com.example.examplenativecommunication

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL_NAME = "com.abc.flutter/method"
    private val PRESSURE_CHANNEL_NAME = "com.abc.flutter/pressure"

    private var methodChannel: MethodChannel? = null

    private lateinit var sensorManager: SensorManager

    private var pressureChannel: EventChannel? = null
    private var pressureStreamHandler: FlutterStreamHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        super.onDestroy()
        killChannels()
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {

        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)

        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "isPressureSensorAvailable" -> {
                    result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
                }
                "getSystemInfo" -> {
                    val version: String = "Android -" + Build.VERSION.RELEASE
                    result.success(version)
                }
                "getCalculation" -> {
                    result.success(tenPlusFive())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        pressureChannel = EventChannel(messenger, PRESSURE_CHANNEL_NAME)
        pressureStreamHandler = FlutterStreamHandler(sensorManager, Sensor.TYPE_PRESSURE)
        pressureChannel!!.setStreamHandler(pressureStreamHandler)

    }

    private fun tenPlusFive(): String {
        val number = 10 + 5;
        return number.toString()
    }

    private fun killChannels() {
        methodChannel!!.setMethodCallHandler(null)
    }

}
