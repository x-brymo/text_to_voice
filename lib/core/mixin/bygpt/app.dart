import 'package:flutter/material.dart';
import 'package:text_to_voice/core/mixin/bygpt/home.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with AI',
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}