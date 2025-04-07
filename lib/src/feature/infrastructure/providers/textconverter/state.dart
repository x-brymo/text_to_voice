// State notifiers and providers
import '../../../data/models/audio_file.dart';
import '../../../data/models/text_file.dart';

class TextConversionState {
  final bool isConverting;
  final String? currentText;
  final String? currentAudioPath;
  final List<TextFile> textFiles;
  final List<AudioFile> generatedAudioFiles;
  final String selectedLanguage;
  final List<String> availableLanguages;

  TextConversionState({
    this.isConverting = false,
    this.currentText,
    this.currentAudioPath,
    this.textFiles = const [],
    this.generatedAudioFiles = const [],
    this.selectedLanguage = 'en-US',
    this.availableLanguages = const ['en-US', 'hi-IN'],
  });

  TextConversionState copyWith({
    bool? isConverting,
    String? currentText,
    String? currentAudioPath,
    List<TextFile>? textFiles,
    List<AudioFile>? generatedAudioFiles,
    String? selectedLanguage,
    List<String>? availableLanguages,
  }) {
    return TextConversionState(
      isConverting: isConverting ?? this.isConverting,
      currentText: currentText ?? this.currentText,
      currentAudioPath: currentAudioPath ?? this.currentAudioPath,
      textFiles: textFiles ?? this.textFiles,
      generatedAudioFiles: generatedAudioFiles ?? this.generatedAudioFiles,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      availableLanguages: availableLanguages ?? this.availableLanguages,
    );
  }
}