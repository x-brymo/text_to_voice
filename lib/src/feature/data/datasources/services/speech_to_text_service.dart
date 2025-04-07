// services/speech_to_text_service.dart
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final Uuid _uuid = const Uuid();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize();
    }
    return _isInitialized;
  }

  Future<String?> startListening(String selectedLocale) async {
    if (!_isInitialized) await initialize();
    
    final completer = Completer<String?>();
    final textBuffer = StringBuffer();
    
    if (_isInitialized) {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            textBuffer.write(result.recognizedWords);
            if (!completer.isCompleted) {
              completer.complete(textBuffer.toString());
            }
          }
        },
        localeId: selectedLocale,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    }
    
    return completer.future;
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<String> saveTranscriptToFile(String text) async {
    try {
      final String fileName = '${_uuid.v4()}.txt';
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDocDir.path}/transcripts/$fileName';
      
      // Ensure directory exists
      final Directory directory = Directory('${appDocDir.path}/transcripts');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      
      // Write text to file
      final File file = File(filePath);
      await file.writeAsString(text);
      
      return filePath;
    } catch (e) {
      print('Error saving transcript: $e');
      rethrow;
    }
  }

  Future<List<String>> getAvailableLocales() async {
    if (!_isInitialized) await initialize();
    final locales = await _speech.locales();
    return locales.map((locale) => locale.localeId).toList();
  }
}
