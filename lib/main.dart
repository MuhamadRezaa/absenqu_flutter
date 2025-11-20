import 'package:absenqu_flutter/screens/absen-masuk/absen_masuk2_screen.dart';
import 'package:absenqu_flutter/screens/absen-masuk/absen_masuk_bulanan_screen.dart';
import 'package:absenqu_flutter/screens/absen-masuk/absen_masuk3_screen.dart';
import 'package:absenqu_flutter/screens/absen-masuk/absen_masuk4_screen.dart';
import 'package:absenqu_flutter/screens/absen-masuk/absen_masuk_screen1.dart';
import 'package:absenqu_flutter/screens/karyawan/psean_pegawai_screen.dart';
import 'package:absenqu_flutter/screens/profile/my_profile_screen.dart';
import 'package:absenqu_flutter/screens/profile/profile_karyawan_screen.dart';
import 'package:absenqu_flutter/screens/karyawan/karyawan_screen.dart';
import 'package:absenqu_flutter/screens/karyawan/karyawan_chat_screen.dart';
import 'package:absenqu_flutter/screens/karyawan/karyawan_textChat_screen.dart';
import 'package:absenqu_flutter/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Small contract:
  // - Inputs: none
  // - Outputs: MaterialApp that routes to ProfileScreen for quick testing
  // - Error modes: missing assets may cause runtime image error; falls back to blank
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsenQu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      // For development/testing make it easy to open ProfileScreen directly.
      // Change initialRoute to '/splash' or remove the routes to restore previous behavior.
      initialRoute: '/absen_masuk',
      routes: {
        '/': (context) => const SplashScreen(),
        '/splash': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/profile_karyawan': (context) => const ProfileKaryawanScreen(),
        '/karyawan_textChat': (context) => const ChatKaryawan(namaPegawai: null, fotoPegawai: null,),
        '/karyawan_chat': (context) => const DataChatPegawai(),
        '/karyawan': (context) => const DataPegawaiPage(),
        '/PseanPegawai': (context) => PseanPegawaiScreen(),
        '/absen_masuk': (context) => AbsenMasukScreen1(),
        '/absen_masuk2': (context) => const AbsenMasuk2Screen(),
        '/absen_masuk3': (context) => const AbsenMasuk3Screen(),
        '/absen_masuk4': (context) => const AbsenMasuk4Screen(),
        '/absen_masuk_bulanan': (context) => const AbsenMasukBulananScreen(),

        
      },
    );
  }
}
