import 'package:flutter/services.dart';

class NativeComunicator {
  static const MethodChannel _channel = MethodChannel('com.example.verygoodcore.tflusecases/native');

  static Future<String> invokeNativeMethod(
    String method, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(method, params);
      return result ?? '';
    } on PlatformException catch (e) {
      return 'Native Error is ${e.message}';
    }
  }
}
