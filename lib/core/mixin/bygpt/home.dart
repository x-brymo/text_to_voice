// import 'package:flutter/material.dart';
// import 'package:text_to_voice/core/mixin/bygpt/services.dart';






// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final GPTService gptService = GPTService();
//   final TTSService ttsService = TTSService();
//   final STTService sttService = STTService();

//   final List<String> messages = [];
//   bool isListening = false;

//   @override
//   void initState() {
//     super.initState();
//     sttService.initSpeech();
//   }

//   void handleVoiceInput() {
//     if (isListening) {
//       sttService.stopListening();
//       setState(() => isListening = false);
//     } else {
//       sttService.startListening((text) async {
//         setState(() {
//           messages.add("You: $text");
//         });
//         final reply = await gptService.sendMessage(text);
//         setState(() {
//           messages.add("Bot: $reply");
//         });
//         await ttsService.speak(reply);
//       });
//       setState(() => isListening = true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('AI Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (_, index) => ListTile(
//                 title: Text(messages[index]),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton.icon(
//               icon: Icon(isListening ? Icons.mic_off : Icons.mic),
//               label: Text(isListening ? 'Stop' : 'Speak'),
//               onPressed: handleVoiceInput,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }