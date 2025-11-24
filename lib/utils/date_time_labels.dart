class IndoDateTimeLabels {
  static const List<String> _bulan = [
    'Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'
  ];
  static const List<String> _hari = [
    'Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'
  ];

  static String hari(DateTime dt) {
    // DateTime.weekday: 1=Mon, 7=Sun
    return _hari[(dt.weekday - 1) % 7];
    }

  static String tanggalPanjang(DateTime dt) {
    return '${dt.day} ${_bulan[dt.month - 1]} ${dt.year}';
  }

  static String jamWIB(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h.$m WIB';
  }
}
