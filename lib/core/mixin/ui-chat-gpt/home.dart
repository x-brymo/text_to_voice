// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:uuid/uuid.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ChatPage(),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State createState() => _ChatPageState();
// }

// class _ChatPageState extends State {
//   final List<types.Message> _messages = [];
//   final types.User _user = const types.User(id: 'user');
//   final _speechToText = SpeechToText();
//   final _flutterTts = FlutterTts();
//   bool _isListening = false;

//   @override
//   void initState() {
//     super.initState();
//     _speechToText.initialize();
//   }

//   void _handleSendPressed(types.PartialText message) async {
//   final textMessage = types.TextMessage(
//     author: _user,
//     createdAt: DateTime.now().millisecondsSinceEpoch,
//     id: const Uuid().v4(),
//     text: message.text,
//   );

//   setState(() {
//     _messages.insert(0, textMessage);
//   });

//   try {
//     final response = await OpenAI.instance.chat.create(
//       model: "gpt-3.5-turbo",
//       messages: [
//         OpenAIChatCompletionChoiceMessageModel(
//           role: OpenAIChatMessageRole.user,
//           content: ,
//         ),
//       ],
//     );

//     // ✅ استخراج النص من العناصر
//     String reply = '';
//     final contentItems = response.choices.first.message.content;

//     if (contentItems != null) {
//       for (final item in contentItems) {
//         if (item is OpenAIChatCompletionChoiceMessageContentItemText) {
//           reply += item.text;
//         }
//       }
//     }

//     final botMessage = types.TextMessage(
//       author: const types.User(id: 'bot'),
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: reply,
//     );

//     setState(() {
//       _messages.insert(0, botMessage);
//     });

//     await _flutterTts.speak(reply);
//   } catch (e) {
//     print("Error during OpenAI chat: $e");
//   }
// }


//   void _handleMic() async {
//     if (_isListening) {
//       _speechToText.stop();
//       setState(() => _isListening = false);
//     } else {
//       setState(() => _isListening = true);
//       _speechToText.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             _handleSendPressed(types.PartialText(text: result.recognizedWords));
//           }
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("ChatGPT Voice Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: Chat(
//               messages: _messages,
//               onSendPressed: _handleSendPressed,
//               user: _user,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
//                   onPressed: _handleMic,
//                 ),
//                 const Text("اضغط لتتكلم"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
