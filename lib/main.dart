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
import 'package:absenqu_flutter/screens/absenlembur/absenlembur.dart';
import 'package:absenqu_flutter/screens/absenlembur/detail_absenlembur.dart';
import 'package:absenqu_flutter/screens/izin/detail_ajukanizin.dart';
import 'package:absenqu_flutter/screens/izin/form_ajukanizin.dart';
import 'package:absenqu_flutter/screens/izin/izin_ajukanizin.dart';
import 'package:absenqu_flutter/screens/izin/proses_ajukanizin.dart';
import 'package:absenqu_flutter/screens/lembur/lembur.dart';
import 'package:absenqu_flutter/screens/lembur/surat_tugas_lembur.dart';
import 'package:absenqu_flutter/screens/slipgaji/slipgaji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  debugPaintSizeEnabled = false;
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
        //fontFamily: 'Kumbh Sans',
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
        '/karyawan_textChat': (context) =>
            const ChatKaryawan(namaPegawai: null, fotoPegawai: null),
        '/karyawan_chat': (context) => const DataChatPegawai(),
        '/karyawan': (context) => const DataPegawaiPage(),
        '/PseanPegawai': (context) => PseanPegawaiScreen(),
        '/absen_masuk': (context) => AbsenMasukScreen1(),
        '/absen_masuk2': (context) => const AbsenMasuk2Screen(),
        '/absen_masuk3': (context) => const AbsenMasuk3Screen(),
        '/absen_masuk4': (context) => const AbsenMasuk4Screen(),
        '/absen_masuk_bulanan': (context) => const AbsenMasukBulananScreen(),

        // IZIN
        '/ajukanizin': (context) => const AjukanIzin(),
        '/form_ajukanizin': (context) => const FormAjukanizin(),
        '/proses_ajukanizin': (context) => const ProsesAjukanIzin(),
        '/detail_ajukanizin': (context) => const DetailAjukanIzin(),

        // LEMBUR
        '/lembur': (context) => const Lembur(),
        '/surat_tugas_lembur': (context) => const SuratTugasLembur(),

        // ABSEN LEMBUR
        '/absenlembur': (context) => const Absenlembur(),
        '/detail_absenlembur': (context) => const DetailAbsenLembur(),

        // SLIP GAJI
        '/slipgaji': (context) => const SlipGaji(),
      },
    );
  }
}
