import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileKaryawanScreen extends StatelessWidget {
  const ProfileKaryawanScreen({super.key});

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
                      const SizedBox(width: 120),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Sandy Pratama, SE, MM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'NIP 1897819010001',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
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
                            const SizedBox(height: 10),
                            const Text(
                              'Kantor Pusat\nBergabung Sejak 2015',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                // === BOX SOSIAL MEDIA ===
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 10, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA3EAE4),
                            Color(0xFF85AFAC),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Instagram
                          InkWell(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFEDA75),
                                    Color(0xFFD62976),
                                    Color(0xFF962FBF),
                                    Color(0xFF4F5BD5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),

                          // Email
                          InkWell(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                                color: Colors.white,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.envelope,
                                color: Colors.red,
                                size: 14,
                              ),
                            ),
                          ),

                          // Facebook
                          InkWell(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1877F2),
                                shape: BoxShape.circle,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               

                // === STACK FOTO + BOX CV ===
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(height: 10),
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
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(title: "Curriculum Vitae (CV)"),
                          SizedBox(height: 16),
                          CVField(
                            title: "Tempat / Tanggal Lahir",
                            value: "Medan / 20 April 1990",
                          ),
                          CVField(
                            title: "Alamat Rumah",
                            value:
                                "Jalan Ringroad, Gang Sunggal, 39-K Medan Sunggal",
                          ),
                          CVField(title: "No Tlp / WA", value: "081965649898"),
                        ],
                      ),
                    ),

                    // FOTO PROFIL
                    Positioned(
                      top: -200,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/profile.png',
                          width: 140,
                          height: 150,
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
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
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
                        CVField(
                          title: "S1",
                          value: "Teknik Informatika – S1 USU",
                        ),
                        CVField(
                          title: "S2",
                          value: "Magister Teknik Informatika – S2 USU",
                        ),
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
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
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
                        CVField(
                          title: "2015 - 2020",
                          value: "Staf IT Akunting dan Keuangan",
                        ),
                        CVField(
                          title: "2021 - 2024",
                          value: "Staf Jaringan dan IT Development",
                        ),
                        CVField(
                          title: "2025 - 2025",
                          value: "Manager IT & Software Development",
                        ),
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

// === Widget Field CV (tanpa ikon pena, full width) ===
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
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity, // ✅ Lebar full mentok kanan
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
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
