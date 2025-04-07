// views/text_to_speech_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/providers/textconverter/notifier.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/file_picker_button.dart';
import '../widgets/language_selector.dart';


class TextToSpeechScreen extends ConsumerStatefulWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends ConsumerState<TextToSpeechScreen> {
  final TextEditingController _textController = TextEditingController();
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final textConversionState = ref.watch(textConverterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To Speech'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Text-To-Speech',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Sample'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LanguageSelector(
                      languages: textConversionState.availableLanguages,
                      selectedLanguage: textConversionState.selectedLanguage,
                      onLanguageSelected: (language) {
                        ref.read(textConverterProvider.notifier).setSelectedLanguage(language);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter text to convert to speech...',
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        ref.read(textConverterProvider.notifier).setText(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: FilePickerButton(
                            label: 'Upload Text',
                            icon: Icons.upload_file,
                            onTap: () {
                              ref.read(textConverterProvider.notifier).pickAndConvertTextFile();
                            },
                            isLoading: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: textConversionState.isConverting 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Icon(Icons.volume_up, color: Colors.white),
                            onPressed: textConversionState.isConverting 
                                ? null 
                                : () {
                                    if (_textController.text.isNotEmpty) {
                                      ref.read(textConverterProvider.notifier)
                                          .convertTextToSpeech(_textController.text);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please enter text or upload a file.'),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (textConversionState.currentAudioPath != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generated Audio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AudioPlayerWidget(
                      filePath: textConversionState.currentAudioPath!,
                      title: 'Generated TTS Audio',
                    ),
                  ],
                ),
              const Spacer(),
              if (textConversionState.currentAudioPath != null)
                ElevatedButton(
                  onPressed: () {
                    // Share or download the file
                    ref.read(textConverterProvider.notifier)
                        .shareGeneratedAudio(textConversionState.currentAudioPath!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Download Audio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
