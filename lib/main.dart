// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:text_to_voice/core/config/permission.dart';
import 'package:text_to_voice/core/mixin/ui-chat-gpt/claud-ai/app.dart';
import 'package:text_to_voice/src/feature/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permissions.init();
  runApp(
    ProviderScope(
      child: HomeScreen(),
    ),
  );
}


