import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background biru
          Container(
            height: 180,
            width: double.infinity,
            color: const Color(0xFF9BB5FF),
          ),

          // Isi halaman
          Column(
            children: [
              const SizedBox(height: 40),

              // Tombol back & Judul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Lupa Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

             Transform.translate(
  offset: const Offset(0, 25), // TURUNKAN 25px (bisa kamu ubah)
  child: Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 40),
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Image.asset(
          'assets/images/absenqu-icon.png',
          height: 65,
        ),
      ],
    ),
  ),
),



              const SizedBox(height: 35),

              // Input nomor HP / WA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Nomor HP / Nomor WA',
                    filled: true,
                    fillColor: const Color(0xFFAFFFFA),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Kami akan mengirimkan kode OTP via WhatsApp\n'
                  'untuk memverifikasi nomor anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),

              const Spacer(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OtpVerificationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAFFFFA),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Rubah Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
