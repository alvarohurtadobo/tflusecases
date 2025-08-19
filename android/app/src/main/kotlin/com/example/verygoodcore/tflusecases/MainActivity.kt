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
        println(">>> takePicture(): inicio")
        try{
            val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            println(">>> Intent creado: $intent")
            imageFile = File(cacheDir, "capture_image.jpg")
            println(">>> File creado en cacheDir: ${imageFile}")

            val authority = applicationContext.packageName + ".provider"
            println(">>> Authority generado: $authority")
            val uri: Uri = FileProvider.getUriForFile(this, authority, imageFile!!)
            intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
            // startActivityForResult(intent, 1001)
            // result.success(imageFile.absolutePath)

            if (intent.resolveActivity(packageManager) != null) {
                println(">>> Cámara encontrada, lanzando intent…")
                startActivityForResult(intent, 1001);
            } else {
                println(">>> No se encontró app de cámara")
                result.error("UNAVAILABLE", "Unable to open camera", null);
            }
        } catch (e: Exception) {
            println(">>> ERROR en takePicture(): ${e.message}")
            e.printStackTrace()
            result.error("ERROR", "Exception in takePicture: ${e.localizedMessage}", null)
        }
    }

    override fun onActivityResult(requestCode: Int,  resultCode: Int, data: Intent?){
        super.onActivityResult(requestCode, resultCode, data);
        println(">>> onActivityResult")
        if(requestCode == 1001 && resultCode == Activity.RESULT_OK){
            // String imagePath = data.getData().toString();
            imageFile?.let {
                println(">>> Imagen guardada en: ${it.absolutePath}")
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("takePicture", it.absolutePath)
            }
        }
    }
}