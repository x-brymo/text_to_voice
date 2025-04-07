// view_models/text_converter_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/services/file_service.dart';
import '../../../data/datasources/services/text_to_speech_service.dart';

// Service providers
final textToSpeechServiceProvider = Provider<TextToSpeechService>((ref) {
  final service = TextToSpeechService();
  service.initialize();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final fileServiceProvider = Provider<FileService>((ref) {
  return FileService();
});