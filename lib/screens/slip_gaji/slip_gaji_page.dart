import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdf;

class SlipGajiPage extends StatelessWidget {
  const SlipGajiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF95E9E4), Color(0xFF9FA9A7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Row(children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage('assets/images/splash-image.png'),
                      ),
                      const SizedBox(width: 8),
                      const Text('Slip Gaji Anda', style: TextStyle(fontWeight: FontWeight.w800)),
                    ]),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 430),
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                              Text('Sandy Pratama, SE, MM', style: TextStyle(fontWeight: FontWeight.w800)),
                              SizedBox(height: 4),
                              Text('NIP 1897819010001'),
                              SizedBox(height: 10),
                              Text('Manajer IT &', style: TextStyle(fontWeight: FontWeight.w700)),
                              Text('Software Development', style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(height: 4),
                              Text('Kantor Pusat'),
                            ]),
                          ),
                          const SizedBox(width: 12),
                          const Text('Periode\n31 Maret 2025', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w800)),
                        ]),

                        const SizedBox(height: 16),
                        _sectionTitle('Perhitungan Penerimaan Gaji Anda'),
                        const SizedBox(height: 8),
                        _itemRow(title: 'Gaji Pokok', formula: 'Rp.3.300.000 x 1 Bulan', amount: 'Rp.3.300.000'),
                        _itemRow(title: 'Uang Makan', formula: 'Rp.20.000 x 20 Hari', amount: 'Rp.400.000'),
                        _itemRow(title: 'Uang Transport', formula: 'Rp.15.000 x 20 Hari', amount: 'Rp.300.000'),
                        _itemRow(title: 'Tunjangan Jabatan', formula: 'Rp.800.000 x 1 Bulan', amount: 'Rp.800.000'),
                        _itemRow(title: 'Insentif', formula: 'Rp.500.000 x 1 Bulan', amount: 'Rp.500.000'),
                        const SizedBox(height: 8),
                        const _SectionDivider(),
                        const SizedBox(height: 8),
                        _totalChipRow('Total Gaji', 'Rp.5.300.000'),

                        const SizedBox(height: 18),
                        _sectionTitle('Perhitungan Potongan Gaji Anda'),
                        const SizedBox(height: 8),
                        _itemRow(title: 'Iuran BPJS', formula: 'Rp.120.000', amount: 'Rp.120.000'),
                        _itemRow(title: 'Iuran Koperasi Karyawan', formula: 'Rp.100.000', amount: 'Rp.100.000'),
                        const SizedBox(height: 8),
                        const _SectionDivider(),
                        const SizedBox(height: 8),
                        _totalChipRow('Total Potongan', 'Rp.220.000'),

                        const SizedBox(height: 18),
                        _doubleDivider(),
                        const SizedBox(height: 8),
                        _totalLabelRow('Gaji Bruto', 'Rp.5.080.000'),
                        _itemRow(title: 'Pajak', formula: 'Rp.210.000', amount: 'Rp.210.000'),
                        _totalLabelRow('Gaji Bersih', 'Rp.4.870.000'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton.icon(
                    onPressed: () => _exportPdf(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Ekspor PDF', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52D5CA),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.w800));
  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      );
  Widget _amountChip(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
  Widget _itemRow({required String title, required String formula, required String amount}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              _chip(formula),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('Jumlah', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            _amountChip(amount),
          ])
        ]),
      );
  Widget _totalChipRow(String label, String amount) => Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
        _amountChip(amount),
      ]);
  Widget _totalLabelRow(String label, String amount) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
      );
  Widget _doubleDivider() => Column(children: [
        Container(height: 1.2, color: Colors.black.withValues(alpha: 0.45)),
        const SizedBox(height: 6),
        Container(height: 1.2, color: Colors.black.withValues(alpha: 0.45)),
      ]);

  Future<void> _exportPdf(BuildContext context) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: pdf.PdfPageFormat.a4,
        build: (ctx) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(children: [
                pw.Expanded(child: pw.Text('Sandy Pratama, SE, MM\nNIP 1897819010001\nManajer IT &\nSoftware Development\nKantor Pusat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(width: 12),
                pw.Text('Periode\n31 Maret 2025', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]),
              pw.SizedBox(height: 14),
              pw.Text('Perhitungan Penerimaan Gaji Anda', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              _pdfRow('Gaji Pokok', 'Rp.3.300.000', sub: 'Rp.3.300.000 x 1 Bulan'),
              _pdfRow('Uang Makan', 'Rp.400.000', sub: 'Rp.20.000 x 20 Hari'),
              _pdfRow('Uang Transport', 'Rp.300.000', sub: 'Rp.15.000 x 20 Hari'),
              _pdfRow('Tunjangan Jabatan', 'Rp.800.000', sub: 'Rp.800.000 x 1 Bulan'),
              _pdfRow('Insentif', 'Rp.500.000', sub: 'Rp.500.000 x 1 Bulan'),
              _pdfTotal('Total Gaji', 'Rp.5.300.000'),
              pw.SizedBox(height: 10),
              pw.Text('Perhitungan Potongan Gaji Anda', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              _pdfRow('Iuran BPJS', 'Rp.120.000', sub: 'Rp.120.000'),
              _pdfRow('Iuran Koperasi Karyawan', 'Rp.100.000', sub: 'Rp.100.000'),
              _pdfTotal('Total Potongan', 'Rp.220.000'),
              pw.SizedBox(height: 10),
              _pdfTotal('Gaji Bruto', 'Rp.5.080.000'),
              _pdfRow('Pajak', 'Rp.210.000'),
              _pdfTotal('Gaji Bersih', 'Rp.4.870.000'),
            ]),
          );
        },
      ),
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: 'slip_gaji_31-03-2025.pdf');
  }

  pw.Widget _pdfRow(String left, String right, {String? sub}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(children: [
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(left, style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
            if (sub != null)
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 4),
                padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: pw.BoxDecoration(
                  color: const pdf.PdfColor(1, 1, 1, 0.7),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(sub, style: const pw.TextStyle(fontSize: 10)),
              ),
          ])),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('Jumlah', style: const pw.TextStyle(fontSize: 10)),
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 4),
              padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: pw.BoxDecoration(
                color: const pdf.PdfColor(1, 1, 1, 0.7),
                borderRadius: pw.BorderRadius.circular(20),
              ),
              child: pw.Text(right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ])
        ]),
      );

  pw.Widget _pdfTotal(String left, String right) => pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: const pw.EdgeInsets.symmetric(vertical: 4),
        decoration: pw.BoxDecoration(color: pdf.PdfColor.fromInt(0xFFF4F4F4), borderRadius: pw.BorderRadius.circular(8)),
        child: pw.Row(children: [
          pw.Expanded(child: pw.Text(left, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Text(right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ]),
      );
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.black.withValues(alpha: 0.35));
  }
}