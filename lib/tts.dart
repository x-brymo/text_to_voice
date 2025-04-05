import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToVoiceByTTS extends StatefulWidget {
  const TextToVoiceByTTS({super.key});

  @override
  _TextToVoiceByTTSState createState() => _TextToVoiceByTTSState();
}

enum text_to_voice_state { playing, stopped }

class _TextToVoiceByTTSState extends State<TextToVoiceByTTS> {
  late FlutterTts flutterTts;
  dynamic languages;
  String language = '';
  double volume = 0.5;
  double pitch = 1.0;
  double speechRate = 0.5;

   String _text_to_convert = '';

  text_to_voice_state ttsState = text_to_voice_state.stopped;

  get isPlaying => ttsState == text_to_voice_state.playing;

  get isStopped => ttsState == text_to_voice_state.stopped;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print('playing voice');
        ttsState = text_to_voice_state.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print('Completed');
        ttsState = text_to_voice_state.stopped;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        print('Error: $message');
        ttsState = text_to_voice_state.stopped;
      });
    });
  }

 Future _getLanguages() async {
  languages = await flutterTts.getLanguages;
  print('Available Languages: $languages');
  if (languages != null) {
    final uniqueLanguages = languages.toSet().toList(); 
    setState(() {
      languages = uniqueLanguages;
      if (uniqueLanguages.isNotEmpty) {
        language = uniqueLanguages.first;
      } else {
        language = '';
      }
    });
  }
}

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        appBar: AppBar(
          title: Text('Text to Voice Converter'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _inputTextField(),
              languages != null ? _languagesDropDownSection() : Text(""),
              _buildSliders()
            ],
          ),
        ),
      ),
    );
  }

  void _onChange(String text) {
    setState(() {
      _text_to_convert = text;
    });
  }

  Widget _inputTextField() => Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
        child: TextField(
          onChanged: (String value) {
            _onChange(value);
          },
        ),
      );

  List<DropdownMenuItem<String>> getLanguagesDropDownItems() {
    var items = <DropdownMenuItem<String>>[];
    for (String languageType in languages) {
      items.add(DropdownMenuItem(
        value: languageType,
        child: Text(languageType),
      ));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    if (selectedType != null) {
      setState(() {
        language = selectedType;
        flutterTts.setLanguage(language);
      });
    }
  }

  Widget _languagesDropDownSection() => Container(
        padding: const EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              DropdownButton<String>(
               value: (languages != null && languages.contains(language)) ? language : null,
                items: getLanguagesDropDownItems(),
                onChanged: changedLanguageDropDownItem,
              ),
            
          ],
        ),
      );

  Widget _buildSliders() {
    return Column(
      children: [_volume(), _pitch(), _speechRate()],
    );
  }

  Widget _volume() {
    return Slider(
      value: volume,
      onChanged: (newVolume) {
        setState(() {
          volume = newVolume;
        });
      },
      max: 1.0,
      min: 0.0,
      divisions: 10,
      label: "Volume: $volume",
      activeColor: Colors.blue,
    );
  }

  Widget _pitch() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() {
          pitch = newPitch;
        });
      },
      max: 2.0,
      min: 0.5,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Widget _speechRate() {
    return Slider(
      value: speechRate,
      onChanged: (newSpeechRate) {
        setState(() {
          speechRate = newSpeechRate;
        });
      },
      max: 1.0,
      min: 0.0,
      divisions: 10,
      label: "SpeechRate: $speechRate",
      activeColor: Colors.green,
    );
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setPitch(pitch);

    if (_text_to_convert.isNotEmpty) {
      var result = await flutterTts.speak(_text_to_convert);
      if (result == 1) {
        setState(() {
          ttsState = text_to_voice_state.playing;
        });
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        ttsState = text_to_voice_state.stopped;
      });
    }
  }

  Widget BottomBar() => Container(
        margin: EdgeInsets.all(10),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _speak,
              backgroundColor: Colors.green,
              child: Icon(Icons.play_arrow),
            ),
            FloatingActionButton(
              onPressed: _stop,
              backgroundColor: Colors.red,
              child: Icon(Icons.stop),
            ),
          ],
        ),
      );
}