// view_models/audio_converter_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/services/audio_service.dart';
import '../../../data/datasources/services/speech_to_text_service.dart';


// Service providers
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final speechToTextServiceProvider = Provider<SpeechToTextService>((ref) {
  return SpeechToTextService();
});