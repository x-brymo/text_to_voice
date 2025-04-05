// splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'tts.dart'; // Adjust import if MyApp is in another file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription _subscription;
  bool _hasConnection = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && !_hasConnection) {
        // Reload app automatically
        setState(() {
          _hasConnection = true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TextToVoiceByTTS()),
        );
      }
    });
  }

  Future<void> _checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      setState(() {
        _hasConnection = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TextToVoiceByTTS()),
      );
    } else {
      setState(() {
        _hasConnection = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: _hasConnection
            ? const CircularProgressIndicator(color: Colors.white)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.wifi_off, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text("لا يوجد اتصال بالإنترنت",
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ],
              ),
      ),
    );
  }
}
