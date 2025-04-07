// State notifiers and providers
import '../../../data/models/audio_file.dart';

class RecordingState {
  final bool isRecording;
  final String? currentRecordingPath;
  final List<AudioFile> recordings;
  final bool isPlaying;
  final String? playingFilePath;

  RecordingState({
    this.isRecording = false,
    this.currentRecordingPath,
    this.recordings = const [],
    this.isPlaying = false,
    this.playingFilePath,
  });

  RecordingState copyWith({
    bool? isRecording,
    String? currentRecordingPath,
    List<AudioFile>? recordings,
    bool? isPlaying,
    String? playingFilePath,
  }) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      currentRecordingPath: currentRecordingPath ?? this.currentRecordingPath,
      recordings: recordings ?? this.recordings,
      isPlaying: isPlaying ?? this.isPlaying,
      playingFilePath: playingFilePath ?? this.playingFilePath,
    );
  }
}