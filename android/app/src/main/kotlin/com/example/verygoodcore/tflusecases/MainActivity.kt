package com.example.verygoodcore.tflusecases


import android.content.Context
import android.os.BatteryManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel




class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.verygoodcore.tflusecases/native"

    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result -> 
            if (call.method == "getBatteryLevel") {
                var batteryLevel = getBatteryLevel()
                if(batteryLevel != -1) {
                    result.success("Battery level: $batteryLevel%")
                } else{
                    result.error("UNAVAILABLE", "Unable to get battery level", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(android.os.BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}