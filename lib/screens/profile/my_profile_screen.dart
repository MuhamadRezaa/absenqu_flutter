import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === FOTO + DATA PROFIL ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 145),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Sandy Pratama, SE, MM',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'NIP 1897819010001',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Manajer IT & Software Development',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Kantor Pusat\nBergabung Sejak 2015',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE4F8A6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              ),
                              child: const Text(
                                'Bagikan Id Card',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // === STACK FOTO + BOX CV ===
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // BOX CV
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC5E9EF), Color(0xFFBBD7DB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40), // cukup top padding agar foto tidak menutupi
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SectionTitle(title: "Curriculum Vitae (CV)"),
                          SizedBox(height: 16),
                          CVField(title: "Tempat / Tanggal Lahir", value: "Medan / 20 April 1990"),
                          CVField(title: "Alamat Rumah", value: "Jalan Ringroad, Gang Sunggal, 39-K Medan Sunggal"),
                          CVField(title: "No Tlp / WA", value: "081965649898"),
                        ],
                      ),
                    ),

                    // FOTO PROFIL
                    Positioned(
                      top: -227, // naik ke atas box CV
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/profile.png',
                          width: 150,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                // === BOX PENDIDIKAN ===
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD7E0EA), Color(0xFFC4CAD1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 60),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(title: "Pendidikan"),
                        SizedBox(height: 16),
                        CVField(title: "SMU", value: "SMU NEGERI 1 Medan"),
                        CVField(title: "S1", value: "Teknik Informatika – S1 USU"),
                        CVField(title: "S2", value: "Magister Teknik Informatika – S2 USU"),
                      ],
                    ),
                  ),
                ),

                // === BOX JENJANG KARIER ===
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDAD9E4), Color(0xFFB4B3B6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(title: "Jenjang Karier"),
                        SizedBox(height: 16),
                        CVField(title: "2015 - 2020", value: "Staf IT Akunting dan Keuangan"),
                        CVField(title: "2021 - 2024", value: "Staf Jaringan dan IT Development"),
                        CVField(title: "2025 - 2025", value: "Manager IT & Software Development"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// === Widget Judul Bagian ===
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}

// === Widget Field CV ===
class CVField extends StatelessWidget {
  final String title;
  final String value;
  const CVField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.black)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                const Icon(Icons.edit, size: 20, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
