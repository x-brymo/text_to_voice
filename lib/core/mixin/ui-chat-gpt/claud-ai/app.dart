// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:text_to_voice/core/mixin/bygpt/home.dart';
// import '../../../../src/feature/data/datasources/services/speech_to_text_service.dart';
// import '../../../../src/feature/data/datasources/services/text_to_speech_service.dart';

// class ClaudAITest extends StatelessWidget {
//   const ClaudAITest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ChatBloc>(
//           create: (context) => ChatBloc(
//             OpenAIService(),
//           ),
//         ),
//         BlocProvider<SpeechBloc>(
//           create: (context) => SpeechBloc(
//             SpeechToTextService(),
//             TextToSpeechService(),
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'AI Conversation App',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.deepPurple,
//             secondary: Colors.teal,
//           ),
//           useMaterial3: true,
//         ),
//         home: const ChatScreen(),
//       ),
//     );
//   }
// }