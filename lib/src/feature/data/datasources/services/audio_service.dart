// services/audio_service.dart
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioService {
  final AudioRecorder _record = AudioRecorder();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final Uuid _uuid = const Uuid();
  bool _isPlayerInitialized = false;
  String? _currentRecordingPath;

  Future<void> initializePlayer() async {
    if (!_isPlayerInitialized) {
      await _player.openPlayer();
      _isPlayerInitialized = true;
    }
  }

  Future<bool> startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        // Generate a file path
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileName = '${_uuid.v4()}.m4a';
        final recordingDirectory = Directory('${appDocDir.path}/recordings');
        
        if (!recordingDirectory.existsSync()) {
          recordingDirectory.createSync(recursive: true);
        }
        
        _currentRecordingPath = '${recordingDirectory.path}/$fileName';
        
        // Start recording
        await _record.start(
          RecordConfig(
            sampleRate: 44100,
            numChannels: 1,
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
          ),
          path: _currentRecordingPath!,
         
        );
        
         
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (await _record.isRecording()) {
        await _record.stop();
        return _currentRecordingPath;
      }
      return null;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  Future<void> playAudio(String filePath) async {
    try {
      await initializePlayer();
      await _player.startPlayer(
        fromURI: filePath,
        whenFinished: () {
          print('Audio playback completed');
        },
      );
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopPlayback() async {
    try {
      if (_player.isPlaying) {
        await _player.stopPlayer();
      }
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  Future<void> dispose() async {
    await _record.dispose();
    await _player.closePlayer();
    _isPlayerInitialized = false;
  }
}