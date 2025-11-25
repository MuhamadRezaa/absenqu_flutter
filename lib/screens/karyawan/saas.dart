import 'package:flutter/material.dart';

class ChatKaryawan extends StatefulWidget {
  const ChatKaryawan({super.key});

  @override
  State<ChatKaryawan> createState() => _ChatKaryawanState();
}

class _ChatKaryawanState extends State<ChatKaryawan> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      'text':
          'Assalammualaikum Pak Rudi, bagaimana dengan progres capaian target penjualan kita bulan ini? Mohon report-nya pak Rudi.',
      'time': '08:10',
      'isMe': false,
      'avatar': 'assets/images/Pegawai1.png',
    },
    {
      'text':
          'Waalaikumsalam Pak, Insya Allah sore ini saya kirimkan dokumennya Pak.',
      'time': '08:15',
      'isMe': true,
    },
    {
      'text': 'Baik, terima kasih Pak Rudi!',
      'time': '08:17',
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
        });
      });
      _chatController.clear();
    }
  }

  void deleteMessage(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pesan"),
        content: const Text("Apakah Anda yakin ingin menghapus pesan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                messages.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
                  // 🔹 Header profil
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              'assets/images/Pegawai1.png',
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
                                          ) // 💚 ganti dengan kode warna dari Figma untuk chat saya
                                        : const Color(
                                            0xFFD5EEED,
                                          ), // 🤍 ganti dengan kode warna dari Figma untuk chat lawan

                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15),
                                      topRight: const Radius.circular(15),
                                      bottomLeft: msg['isMe']
                                          ? const Radius.circular(15)
                                          : const Radius.circular(15),
                                      bottomRight: msg['isMe']
                                          ? const Radius.circular(15)
                                          : const Radius.circular(15),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 28,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (!msg['isMe'])
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 14,
                                                    backgroundImage: AssetImage(
                                                      msg['avatar'] ??
                                                          'assets/images/Pegawai1.png',
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
                                              Text(
                                                msg['text'],
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
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

                                      // 🔹 Tombol dropdown seperti WA
                                    
// 🔹 Tombol titik tiga (posisi dinamis & tidak menimpa bubble)
Positioned(
  top: 0,
  left: msg['isMe'] ? -24 : null,  // geser ke luar kiri sedikit
  right: msg['isMe'] ? null : -30, // geser ke luar kanan sedikit
  child: PopupMenuButton<String>(
    icon: const Icon(
      Icons.more_vert,
      size: 18,
      color: Colors.black54,
    ),
    onSelected: (value) {
      if (value == 'hapus') {
        deleteMessage(index);
      }
    },
    itemBuilder: (context) => [
      const PopupMenuItem(
        value: 'hapus',
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
              size: 18,
            ),
            SizedBox(width: 8),
            Text("Hapus Pesan"),
          ],
        ),
      ),
    ],
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

                  // 🔹 Input Chat Bawah
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: const InputDecoration(
                                hintText: "Ketik pesan...",
                                border: InputBorder.none,
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: sendMessage,
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.black87,
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
