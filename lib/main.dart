import 'package:absenqu_flutter/screens/reimburse/reimburse_screen.dart';
import 'screens/challenge/challenge_employee_page.dart';
import 'screens/olahraga/olahraga_challenge_page.dart';
import 'screens/slip_gaji/slip_gaji_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsenQu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/challenge': (_) => const ChallengeEmployeePage(),
        '/olahraga': (_) => const OlahragaChallengePage(),
       '/slipgaji': (_) => const SlipGajiPage(),
      },
      home: const ChallengeEmployeePage(),
    );
  }
}
