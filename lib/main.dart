// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request permissions
  await [
    Permission.microphone,
    Permission.storage,
  ].request();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


