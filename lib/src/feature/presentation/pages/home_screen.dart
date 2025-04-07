// views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'record_screen.dart';
import 'text_to_speech_screen.dart';
import 'speech_to_text_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Converter Voice App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildFeatureCard(
                context,
                title: 'Record Audio',
                description: 'Record your voice and convert to text',
                icon: Icons.mic,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecordScreen()),
                ),
              ),
              const SizedBox(height: 20),
              _buildFeatureCard(
                context,
                title: 'Text to Speech',
                description: 'Convert text to spoken audio',
                icon: Icons.record_voice_over,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextToSpeechScreen()),
                ),
              ),
              const SizedBox(height: 20),
              _buildFeatureCard(
                context,
                title: 'Speech to Text',
                description: 'Convert audio files to text',
                icon: Icons.text_fields,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeechToTextScreen()),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(" @copyrights 2025 \n All Rights Reserved ",
                 style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,                
                  fontSize: 14, 
                  overflow: TextOverflow.ellipsis,
                
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}