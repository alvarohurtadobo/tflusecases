import 'package:speech_to_text/speech_recognition_result.dart' as str;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isListening = false;

  String _recognizedText = '';

  void _onSpeechResult(str.SpeechRecognitionResult result) {
    _recognizedText = result.recognizedWords;
  }

  Future<void> startListening() async {
    final available = await _speechToText.initialize();
    if (available) {
      _isListening = true;
      await _speechToText.listen(onResult: _onSpeechResult);
    } else {
      _recognizedText = 'The speech recognizer is not available';
    }
  }

  void stopListening() {
    _speechToText.stop();
    _isListening = false;
  }

  String get recognizedText => _recognizedText;

  bool get isListening => _isListening;
}
