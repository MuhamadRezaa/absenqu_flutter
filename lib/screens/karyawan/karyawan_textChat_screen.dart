
import 'package:flutter/material.dart';

class ChatKaryawan extends StatefulWidget {
  const ChatKaryawan({super.key, required namaPegawai, required fotoPegawai});

  @override
  State<ChatKaryawan> createState() => _ChatKaryawanState();
}

class _ChatKaryawanState extends State<ChatKaryawan> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      'text':
          'Assalammualaikum Pak Andi, bagaimana dengan progres capaian target penjualan kita bulan ini? Mohon report-nya Pak.',
      'time': '08:15',
      'isMe': false,
      'avatar': 'assets/images/Pegawai1.png',
    },
  ];

  void sendMessage() {
    final text = _chatController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': text,
          'time':
              "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          'isMe': true,
          'avatar': 'assets/images/Pegawai2.png',
        });
      });
      _chatController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // 🔹 Header profil kamu (Rudi)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 20,
                      top: 28,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 🧑‍💼 Profil transparan
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              0.2,
                            ), // transparan lembut
                            border: Border.all(
                              color: const Color.fromARGB(
                                255,
                                248,
                                6,
                                6,
                              ).withOpacity(0.6),
                              width: 1.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.transparent, // transparan
                            backgroundImage: AssetImage(
                              'assets/images/Pegawai2.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rudi Admojo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Staf Marketing",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Kantor Cabang Ringroad",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
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
                          hintText: 'Cari Chat',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Area Chat
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
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: msg['isMe']
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: IntrinsicWidth(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(
                                    maxWidth: 280,
                                    minWidth: 50,
                                  ),
                                  decoration: BoxDecoration(
                                    color: msg['isMe']
                                        ? const Color(
                                            0xFFD5EEED,
                                          ).withOpacity(0.9)
                                        : const Color(
                                            0xFFD5EEED,
                                          ).withOpacity(0.9),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!msg['isMe'])
                                        // 🔵 Lawan bicara (Pak Andi)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    246,
                                                    6,
                                                    6,
                                                  ).withOpacity(0.6),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: AssetImage(
                                                  msg['avatar'] ??
                                                      'assets/images/Pegawai1.png',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                msg['text'],
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        // 🟢 Kamu (Rudi)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                msg['text'],
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    245,
                                                    7,
                                                    7,
                                                  ).withOpacity(0.6),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: AssetImage(
                                                  msg['avatar'] ??
                                                      'assets/images/Pegawai2.png',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          msg['time'],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // 🔹 Input Chat
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🟢 Input teks
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: const InputDecoration(
                                hintText: "Ketik pesan...",
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),

                          // 🔹 Ikon kamera, galeri, kirim — JARAK KECIL (3px)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // TODO: Tambahkan fungsi kamera
                                },
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 7), // jarak kecil
                              GestureDetector(
                                onTap: () {
                                  // TODO: Tambahkan fungsi galeri
                                },
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 7), // jarak kecil
                              GestureDetector(
                                onTap: sendMessage,
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ),
                            ],
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
