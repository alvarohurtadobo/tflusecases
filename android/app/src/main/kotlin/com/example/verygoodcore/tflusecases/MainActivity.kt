package com.example.verygoodcore.tflusecases

import android.app.Activity
import android.content.Context
import android.content.Intent 
import android.net.Uri 
import android.os.BatteryManager
import android.os.Bundle
import android.provider.MediaStore 
import androidx.core.content.FileProvider 
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.verygoodcore.tflusecases/native"

    private var imageFile: File? = null

    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result -> when (call.method) {
                "takePicture" -> {
                    takePicture(result)
                }
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success("Battery level: $batteryLevel%")
                    } else {
                        result.error("UNAVAILABLE", "Unable to get battery level", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(android.os.BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun takePicture(result: MethodChannel.Result){ 
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        imageFile = File(cacheDir, "capture_image.jpg")
        val uri: Uri = FileProvider.getUriForFile(this, "$packageName.provider", imageFile!!)
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
        // startActivityForResult(intent, 1001)
        // result.success(imageFile.absolutePath)

        if (intent.resolveActivity(packageManager) != null) {
            startActivityForResult(intent, 1001);
        } else {
            result.error("UNAVAILABLE", "Unable to open camera", null);
        }
    }

    override fun onActivityResult(requestCode: Int,  resultCode: Int, data: Intent?){
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == 1001 && resultCode == Activity.RESULT_OK && data != null){
            // String imagePath = data.getData().toString();
            imageFile?.let {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("takePicture", it.absolutePath)
            }
        }

        // new MethodChannel(getFlutterEngine(.getDartExecutor(), CHANNEL)).invoteMethod("takePicture", imagePath);
    }
}