// views/widgets/audio_player_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/providers/audios/recording_notifier_provider.dart';

class AudioPlayerWidget extends ConsumerStatefulWidget {
  final String filePath;
  final String? title;
  final bool showShareButton;

  const AudioPlayerWidget({
    Key? key, 
    required this.filePath,
    this.title,
    this.showShareButton = true,
  }) : super(key: key);

  @override
  ConsumerState<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget> {
  double _progressValue = 0;
  bool _isPlaying = false;
  
  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingProvider);
    
    if (recordingState.isPlaying && recordingState.playingFilePath == widget.filePath) {
      _isPlaying = true;
    } else {
      _isPlaying = false;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.red.shade400,
                  size: 40,
                ),
                onPressed: () {
                  if (_isPlaying) {
                    ref.read(recordingProvider.notifier).stopPlayback();
                  } else {
                    ref.read(recordingProvider.notifier).playRecording(widget.filePath);
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        trackHeight: 4,
                        activeTrackColor: Colors.red.shade400,
                        inactiveTrackColor: Colors.grey[700],
                        thumbColor: Colors.white,
                        overlayColor: Colors.red.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _progressValue,
                        onChanged: (value) {
                          setState(() {
                            _progressValue = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(Duration(seconds: (_progressValue * 60).round())),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            _formatDuration(const Duration(seconds: 60)),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showShareButton)
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}