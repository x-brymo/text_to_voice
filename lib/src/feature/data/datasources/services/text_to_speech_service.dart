// services/text_to_speech_service.dart
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  final Uuid _uuid = const Uuid();
  
  Future<void> initialize() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }
  
  Future<String?> speak(String text) async {
    await _flutterTts.speak(text);
    return null; // Just speaking, not saving
  }
  
  Future<String?> synthesizeToFile(String text, String language) async {
    try {
      // Set language
      await _flutterTts.setLanguage(language);
      
      // Generate a unique filename
      final String fileName = '${_uuid.v4()}.mp3';
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDocDir.path}/recordings/$fileName';
      
      // Ensure directory exists
      final Directory directory = Directory('${appDocDir.path}/recordings');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      
      // Synthesize text to file
      await _flutterTts.synthesizeToFile(text, filePath);
      
      return filePath;
    } catch (e) {
      print('Error synthesizing to file: $e');
      return null;
    }
  }
  
  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages.cast<String>();
    } catch (e) {
      return ['en-US', 'hi-IN']; // Fallback to basic languages
    }
  }
  
  void dispose() {
    _flutterTts.stop();
  }
}