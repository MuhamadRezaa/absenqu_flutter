import 'package:flutter/material.dart';

// Halaman utama Data Pegawai
class DataChatPegawai extends StatefulWidget {
  const DataChatPegawai({super.key});

  @override
  State<DataChatPegawai> createState() => _DataChatPegawaiState();
}

class _DataChatPegawaiState extends State<DataChatPegawai> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> pegawaiList = [
    {
      "nama": "Rudi Admojo",
      "jabatan": "Staf Marketing",
      "lokasi": "Kantor Cabang Ringroad",
      "telepon": "081197775554",
      "lamaKerja": "1 Tahun 2 Bulan",
      "foto": "assets/images/Pegawai1.png",
    },
    {
      "nama": "Sany Pratama",
      "jabatan": "Staf Marketing",
      "lokasi": "Kantor Cabang Ringroad",
      "telepon": "08116578945",
      "lamaKerja": "1 Tahun 2 Bulan",
      "foto": "assets/images/Pegawai2.png",
    },
    {
      "nama": "Budi Santoso",
      "jabatan": "Supervisor Lapangan",
      "lokasi": "Kantor Pusat Medan",
      "telepon": "081234567890",
      "lamaKerja": "2 Tahun 5 Bulan",
      "foto": "assets/images/Pegawai1.png",
    },
    {
      "nama": "Lina Hartati",
      "jabatan": "Admin Keuangan",
      "lokasi": "Kantor Cabang Binjai",
      "telepon": "081312345678",
      "lamaKerja": "3 Tahun",
      "foto": "assets/images/Pegawai2.png",
    },
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
            colors: [
              Color(0xFF8DE9E5),
              Color.fromARGB(255, 75, 75, 75),
            ],
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
                  // Tombol kembali dan logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Transform.translate(
                          offset: const Offset(-5, 10),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
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

                  // Kontainer data pegawai
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
                          // 🔹 Baris Data Pegawai + Chat
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Data Pegawai',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final data = filteredList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                          data["foto"] ?? "assets/images/profile.png",
                                        ),
                                        onBackgroundImageError: (exception, stackTrace) {
                                          debugPrint("⚠️ Gagal memuat foto: ${data["foto"]}");
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            data["telepon"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            data["lamaKerja"],
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
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


