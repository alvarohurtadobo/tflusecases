import android.os.bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

package com.example.verygoodcore.tflusecases



class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.verygoodcore.tflusecases/native"

    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler {
            call, result -> 
            if (call.method == "getBatteryLevel") {
                var batteryLevel = getBatteryLevel()
                if(batteryLevel != -1) {
                    result.success("Battery level: $batteryLevel%")
                } else{
                    result.error("Unable to get")
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(BATTERY_SERVICE) as android.os.batteryManager
        return batteryManager.getIntProperty(android.os.batteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}