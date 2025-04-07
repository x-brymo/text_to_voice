// views/widgets/language_selector.dart
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final List<String> languages;
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language == selectedLanguage;
          
          return GestureDetector(
            onTap: () => onLanguageSelected(language),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.shade400 : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  _getLanguageLabel(language),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  String _getLanguageLabel(String languageCode) {
    // Common language codes
    final Map<String, String> languageLabels = {
      'en-US': 'English',
      'hi-IN': 'Hindi',
      'es-ES': 'Spanish',
      'fr-FR': 'French',
      'de-DE': 'German',
      'ja-JP': 'Japanese',
      'zh-CN': 'Chinese',
    };
    
    return languageLabels[languageCode] ?? languageCode;
  }
}