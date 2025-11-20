import 'package:flutter/material.dart';

class PseanPegawaiScreen extends StatefulWidget {
  const PseanPegawaiScreen({super.key});

  @override
  State<PseanPegawaiScreen> createState() => _PseanPegawaiScreenState();
}

class _PseanPegawaiScreenState extends State<PseanPegawaiScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> pegawaiList = [
    {
      "nama": "Rudi Admojo",
      "jabatan": "Staf Marketing",
      "lokasi": "Kantor Cabang Ringroad",
      "foto": "assets/images/Pegawai1.png",
      "unread": 1, // jumlah chat belum dibaca
    },
    {
      "nama": "Sari Rahmadani",
      "jabatan": "Staf Keuangan",
      "lokasi": "Kantor Pusat Padang",
      "foto": "assets/images/Pegawai2.png",
      "unread": 0,
    },
    // {
    //   "nama": "Budi Santoso",
    //   "jabatan": "Customer Support",
    //   "lokasi": "Cabang Bukittinggi",
    //   "foto": "assets/images/Pegawai3.png",
    //   "unread": 2,
    // },
  ];

  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = pegawaiList;
    _searchController.addListener(_filterPegawai);
  }

  void _filterPegawai() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredList = pegawaiList.where((pegawai) {
        final nama = pegawai['nama'].toLowerCase();
        final jabatan = pegawai['jabatan'].toLowerCase();
        final lokasi = pegawai['lokasi'].toLowerCase();
        return nama.contains(query) ||
            jabatan.contains(query) ||
            lokasi.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Jumlah data tampil: ${filteredList.length}");

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8DE9E5), Color.fromARGB(255, 75, 75, 75)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background atas
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFEAD9FF),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali & logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Transform.translate(
                          offset: const Offset(-5, 10),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            iconSize: 35,
                          ),
                        ),
                        const Spacer(),
                        Transform.translate(
                          offset: const Offset(-14, 20),
                          child: Image.asset(
                            'assets/images/Logo.png',
                            height: 65,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari Data Anda',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kontainer utama
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFAEEBE8), Color(0xFFB7B7B7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Baris atas: Data Pegawai + Chat global
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pesan Pegawai',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/karyawan_textChat',
                                  );
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 46,
                                        right: 16,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCAF5F3),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      child: const Text(
                                        "Pesan",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: -10,
                                      top: -3,
                                      bottom: -3,
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0B5408),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/images/Chat.png',
                                          width: 25,
                                          height: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // List Pegawai + tombol chat per item
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final data = filteredList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Opacity(
                                        opacity: 0.9, // misal 90% terlihat
                                        child: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: Image.asset(
                                              data["foto"] ??
                                                  "assets/images/profile.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data["nama"],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              data["jabatan"],
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              data["lokasi"],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Tombol Chat dengan notifikasi
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/karyawan_textChat',
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF0B5408),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                'assets/images/Chat.png',
                                                width: 22,
                                                height: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                          // 🔴 Badge notifikasi merah
                                          if ((data["unread"] ?? 0) > 0)
                                            Positioned(
                                              right: -2,
                                              top: -2,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${data["unread"]}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
