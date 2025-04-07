// views/speech_to_text_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/providers/audios/recording_notifier_provider.dart';
import '../../infrastructure/providers/textconverter/notifier.dart';
import '../widgets/file_picker_button.dart';
import '../widgets/language_selector.dart';


class SpeechToTextScreen extends ConsumerStatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends ConsumerState<SpeechToTextScreen> {
  String? _transcribedText;
  bool _isConverting = false;
  String _selectedLanguage = 'en-US';
  
  @override
  Widget build(BuildContext context) {
    final textConversionState = ref.watch(textConverterProvider);
    final recordingState = ref.watch(recordingProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech To Text'),
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
                          'Speech-To-Text',
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
                      selectedLanguage: _selectedLanguage,
                      onLanguageSelected: (language) {
                        setState(() {
                          _selectedLanguage = language;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    FilePickerButton(
                      label: 'Upload Audio File',
                      icon: Icons.music_note,
                      onTap: () async {
                        setState(() {
                          _isConverting = true;
                        });
                        
                        // Simulate conversion as this would require a proper API
                        await Future.delayed(const Duration(seconds: 2));
                        
                        setState(() {
                          _transcribedText = "This is a simulation of speech-to-text conversion. In a real implementation, you would integrate with a service like Google Cloud Speech-to-Text or similar APIs to transcribe the audio file content.";
                          _isConverting = false;
                        });
                      },
                      isLoading: _isConverting,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_transcribedText != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transcribed Text',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _transcribedText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Copy to clipboard functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Text copied to clipboard'),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[600]!),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Copy Text'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Save text functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Text saved successfully'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Save Text'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}