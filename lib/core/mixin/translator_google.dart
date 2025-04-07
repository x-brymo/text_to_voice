// import 'package:flutter/material.dart';
// import 'package:translator/translator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';



// class TextToVoiceByGoogle extends StatefulWidget {
//   const TextToVoiceByGoogle({super.key});

//   @override
//   _TextToVoiceByGoogleState createState() => _TextToVoiceByGoogleState();
// }

// enum text_to_voice_state { playing, stopped }

// class _TextToVoiceByGoogleState extends State<TextToVoiceByGoogle> {
//   final translator = GoogleTranslator();
//   FlutterSoundRecorder recorder = FlutterSoundRecorder();
//   String? recordingPath;

//   dynamic languages;
//   String language = '';
//   double volume = 0.5;
//   double pitch = 1.0;
//   double speechRate = 0.5;

//   String _text_to_convert = '';

//   text_to_voice_state ttsState = text_to_voice_state.stopped;

//   get isPlaying => ttsState == text_to_voice_state.playing;

//   get isStopped => ttsState == text_to_voice_state.stopped;

//   @override
//   void initState() {
//     super.initState();
//     initTts();
//     initRecorder();
//   }

//   initTts() {
//     flutterTts = FlutterTts();

//     _getLanguages();

//     flutterTts.setStartHandler(() {
//       setState(() {
//         ttsState = text_to_voice_state.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() async {
//       setState(() {
//         ttsState = text_to_voice_state.stopped;
//       });
//       await stopRecording();
//     });

//     flutterTts.setErrorHandler((message) {
//       setState(() {
//         ttsState = text_to_voice_state.stopped;
//       });
//     });
//   }

//   Future initRecorder() async {
//     await Permission.microphone.request();
//     await recorder.openRecorder();
//   }

//   Future _getLanguages() async {
//     languages = await flutterTts.getLanguages;
//     if (languages != null) {
//       final uniqueLanguages = languages.toSet().toList();
//       setState(() {
//         languages = uniqueLanguages;
//         language = uniqueLanguages.isNotEmpty ? uniqueLanguages.first : '';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     recorder.closeRecorder();
//     super.dispose();
//   }

//   void _onChange(String text) {
//     setState(() {
//       _text_to_convert = text;
//     });
//   }

//   Future<void> _translate() async {
//     if (_text_to_convert.isNotEmpty) {
//       var translation = await translator.translate(_text_to_convert, from: 'ar', to: 'en');
//       setState(() {
//         _text_to_convert = translation.text;
//       });
//     }
//   }

//   Future<String> _getFilePath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return '${dir.path}/tts_record.aac';
//   }

//   Future<void> startRecording() async {
//     recordingPath = await _getFilePath();
//     await recorder.startRecorder(toFile: recordingPath);
//   }

//   Future<void> stopRecording() async {
//     await recorder.stopRecorder();
//   }

//   Future<void> _speak() async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setSpeechRate(speechRate);
//     await flutterTts.setPitch(pitch);
//     await startRecording();
//     if (_text_to_convert.isNotEmpty) {
//       await flutterTts.speak(_text_to_convert);
//     }
//   }

//   Future<void> _stop() async {
//     await flutterTts.stop();
//     await stopRecording();
//   }

//   void _downloadRecording() async {
//     if (recordingPath != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('File saved at $recordingPath')),
//       );
//     }
//   }

//   List<DropdownMenuItem<String>> getLanguagesDropDownItems() {
//     var items = <DropdownMenuItem<String>>[];
//     for (String languageType in languages) {
//       items.add(DropdownMenuItem(
//         value: languageType,
//         child: Text(languageType),
//       ));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String? selectedType) {
//     if (selectedType != null) {
//       setState(() {
//         language = selectedType;
//         flutterTts.setLanguage(language);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Text to Voice Converter'),
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               _inputTextField(),
//               languages != null ? _languagesDropDownSection() : SizedBox(),
//               _buildSliders(),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomBar(),
//       ),
//     );
//   }

//   Widget _inputTextField() => Container(
//         alignment: Alignment.topCenter,
//         padding: const EdgeInsets.all(25),
//         child: TextField(
//           onChanged: _onChange,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Enter text (Arabic)',
//           ),
//         ),
//       );

//   Widget _languagesDropDownSection() => Container(
//         padding: const EdgeInsets.only(top: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DropdownButton<String>(
//               value: (languages != null && languages.contains(language)) ? language : null,
//               items: getLanguagesDropDownItems(),
//               onChanged: changedLanguageDropDownItem,
//             ),
//           ],
//         ),
//       );

//   Widget _buildSliders() => Column(children: [_volume(), _pitch(), _speechRate()]);

//   Widget _volume() => Slider(
//         value: volume,
//         onChanged: (newVolume) => setState(() => volume = newVolume),
//         max: 1.0,
//         min: 0.0,
//         divisions: 10,
//         label: "Volume: $volume",
//         activeColor: Colors.blue,
//       );

//   Widget _pitch() => Slider(
//         value: pitch,
//         onChanged: (newPitch) => setState(() => pitch = newPitch),
//         max: 2.0,
//         min: 0.5,
//         divisions: 15,
//         label: "Pitch: $pitch",
//         activeColor: Colors.red,
//       );

//   Widget _speechRate() => Slider(
//         value: speechRate,
//         onChanged: (newSpeechRate) => setState(() => speechRate = newSpeechRate),
//         max: 1.0,
//         min: 0.0,
//         divisions: 10,
//         label: "SpeechRate: $speechRate",
//         activeColor: Colors.green,
//       );

//   Widget BottomBar() => Container(
//         margin: EdgeInsets.all(10),
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             FloatingActionButton(
//               onPressed: _speak,
//               backgroundColor: Colors.green,
//               child: Icon(Icons.play_arrow),
//             ),
//             FloatingActionButton(
//               onPressed: _stop,
//               backgroundColor: Colors.red,
//               child: Icon(Icons.stop),
//             ),
//             FloatingActionButton(
//               onPressed: _translate,
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.translate),
//             ),
//             FloatingActionButton(
//               onPressed: _downloadRecording,
//               backgroundColor: Colors.orange,
//               child: Icon(Icons.download),
//             ),
//           ],
//         ),
//       );
// }
