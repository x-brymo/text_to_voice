import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/services/audio_service.dart';
import '../../../data/datasources/services/speech_to_text_service.dart';
import '../../../data/models/audio_file.dart';
import 'audio_converter_provider.dart';
import 'audio_state_notifiers.dart';

class RecordingNotifier extends StateNotifier<RecordingState> {
  final AudioService _audioService;
  final SpeechToTextService _speechToTextService;

  RecordingNotifier(this._audioService, this._speechToTextService)
      : super(RecordingState());

  Future<void> startRecording() async {
    if (await _audioService.startRecording()) {
      state = state.copyWith(isRecording: true);
    }
  }

  Future<void> stopRecording() async {
    if (state.isRecording) {
      final recordingPath = await _audioService.stopRecording();
      if (recordingPath != null) {
        final newRecording = AudioFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: recordingPath,
          duration: const Duration(seconds: 1), // This would be calculated
          createdAt: DateTime.now(),
        );
        
        state = state.copyWith(
          isRecording: false,
          currentRecordingPath: recordingPath,
          recordings: [...state.recordings, newRecording],
        );
      }
    }
  }

  Future<void> playRecording(String filePath) async {
    await _audioService.playAudio(filePath);
    state = state.copyWith(isPlaying: true, playingFilePath: filePath);
  }

  Future<void> stopPlayback() async {
    await _audioService.stopPlayback();
    state = state.copyWith(isPlaying: false, playingFilePath: null);
  }

  Future<String?> convertSpeechToText(String audioFilePath, String locale) async {
    try {
      // This is a placeholder. In a real app, you would integrate with a service
      // that can transcribe audio files. Speech-to-text typically works with
      // live microphone input rather than files.
      return "This is a placeholder for speech-to-text conversion";
    } catch (e) {
      print('Error converting speech to text: $e');
      return null;
    }
  }
}

final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(
    ref.watch(audioServiceProvider),
    ref.watch(speechToTextServiceProvider),
  );
});