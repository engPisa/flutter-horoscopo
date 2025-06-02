import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/home_page.dart';
import 'pages/horoscope_page.dart';
import 'pages/password_generator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HoroscopePasswordApp());
}

class HoroscopePasswordApp extends StatelessWidget {
  const HoroscopePasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horóscopo e Senhas',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/horoscope': (context) => const HoroscopePage(),
        '/password-generator': (context) => const PasswordGeneratorPage(),
      },
    );
  }
}
