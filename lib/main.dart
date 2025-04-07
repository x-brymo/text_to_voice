// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:text_to_voice/core/config/permission.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permissions.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


