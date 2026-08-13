import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_theme.dart';
import 'package:key_handover_flutter/features/home/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KeyHandoverApp());
}

class KeyHandoverApp extends StatelessWidget {
  const KeyHandoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Key Handover Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
