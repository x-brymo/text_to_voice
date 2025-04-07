import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_to_voice/src/feature/data/models/audio_file.dart';

import '../../../data/datasources/services/file_service.dart';
import '../../../data/datasources/services/text_to_speech_service.dart';
import '../../../data/models/text_file.dart';
import 'state.dart';
import 'text_converter_provider.dart';

class TextConverterNotifier extends StateNotifier<TextConversionState> {
  final TextToSpeechService _ttsService;
  final FileService _fileService;

  TextConverterNotifier(this._ttsService, this._fileService)  
      : super(TextConversionState()) {
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final languages = await _ttsService.getAvailableLanguages();
    state = state.copyWith(availableLanguages: languages);
  }

  void setSelectedLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void setText(String text) {
    state = state.copyWith(currentText: text);
  }

  Future<void> convertTextToSpeech(String text) async {
    state = state.copyWith(isConverting: true);
    
    try {
      final audioPath = await _ttsService.synthesizeToFile(
        text, 
        state.selectedLanguage
      );
      
      if (audioPath != null) {
        final newAudioFile = AudioFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: audioPath,
          name: "TTS_${DateTime.now().toString()}",
          duration: const Duration(seconds: 10), // Placeholder
          createdAt: DateTime.now(),
        );
        
        state = state.copyWith(
          isConverting: false,
          currentAudioPath: audioPath,
          generatedAudioFiles: [...state.generatedAudioFiles, newAudioFile],
        );
      }
    } catch (e) {
      print('Error converting text to speech: $e');
      state = state.copyWith(isConverting: false);
    }
  }

  Future<void> pickAndConvertTextFile() async {
    try {
      final File? pickedFile = await _fileService.pickTextFile();
      
      if (pickedFile != null) {
        final String content = await _fileService.readTextFile(pickedFile);
        
        final TextFile textFile = TextFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: pickedFile.path,
          name: pickedFile.path.split('/').last,
          content: content,
          createdAt: DateTime.now(),
        );
        
        state = state.copyWith(
          currentText: content,
          textFiles: [...state.textFiles, textFile],
        );
        
        // Convert to speech
        await convertTextToSpeech(content);
      }
    } catch (e) {
      print('Error picking text file: $e');
    }
  }

  Future<void> shareGeneratedAudio(String filePath) async {
    await _fileService.shareFile(filePath);
  }
}

final textConverterProvider = StateNotifierProvider<TextConverterNotifier, TextConversionState>((ref) {
  return TextConverterNotifier(
    ref.watch(textToSpeechServiceProvider),
    ref.watch(fileServiceProvider),
  );
});