import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'finance_provider.dart';
import 'customer_loan_modules.dart';

class MonthGivenScreen extends StatelessWidget {
  const MonthGivenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(builder: (ctx, fp, _) {
      final now = DateTime.now();

      final monthLoans = fp.loans.where((l) {
        try {
          // 👈 FIX: Changed startDate to loanDate
          final d = DateTime.parse(l.loanDate);
          return d.month == now.month && d.year == now.year;
        } catch (e) {
          return false;
        }
      }).toList();

      final Map<String, List<Loan>> grouped = {};
      for (var l in monthLoans) {
        grouped.putIfAbsent(l.customerId, () => []).add(l);
      }

      return Scaffold(
        backgroundColor: const Color(0xFF070B14),
        appBar: AppBar(
          backgroundColor: const Color(0xFF070B14),
          title: const Text('Given This Month', style: TextStyle(color: Color(0xFFEDF2FF))),
          iconTheme: const IconThemeData(color: Color(0xFF00E5A0)),
          actions: [
            if (grouped.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFFF6B6B)),
                tooltip: 'Export PDF',
                onPressed: () => _generatePDF(context, fp, grouped, now),
              )
          ],
        ),
        body: grouped.isEmpty
            ? const Center(child: Text('No loans given this month.', style: TextStyle(color: Color(0xFF7B8FAD))))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: grouped.length,
          itemBuilder: (ctx, i) {
            final customerId = grouped.keys.elementAt(i);
            final customer = fp.customerById(customerId);
            final customerLoans = grouped[customerId]!;

            // 👈 FIX: Changed principalAmount to amountGiven
            final totalGiven = customerLoans.fold(0.0, (sum, l) => sum + l.amountGiven);

            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Card(
                color: const Color(0xFF141E2E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  iconColor: const Color(0xFF00E5A0),
                  collapsedIconColor: const Color(0xFF7B8FAD),
                  title: Text(
                    customer?.fullName ?? 'Unknown Customer',
                    style: const TextStyle(color: Color(0xFFEDF2FF), fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Total Given: ₹${totalGiven.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  children: customerLoans.map((loan) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: const Color(0xFF243050).withOpacity(0.5))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 👈 FIX: Changed startDate to loanDate, principalAmount to amountGiven
                          Text('Date: ${loan.loanDate}', style: const TextStyle(color: Color(0xFF7B8FAD), fontSize: 12)),
                          Text('₹${loan.amountGiven.toStringAsFixed(0)}',
                              style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ── PDF GENERATOR ──────────────────────────────────────────

  Future<void> _generatePDF(BuildContext context, FinanceProvider fp, Map<String, List<Loan>> grouped, DateTime now) async {
    final pdf = pw.Document();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final monthStr = '${months[now.month - 1]} ${now.year}';

    double grandTotal = 0;
    for(var list in grouped.values) {
      // 👈 FIX: Changed principalAmount to amountGiven
      grandTotal += list.fold(0.0, (s, l) => s + l.amountGiven);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Erramala Finance', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                      pw.Text('Loans Given: $monthStr', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    ]
                )
            ),
            pw.SizedBox(height: 20),

            pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey200,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Disbursed This Month:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Rs. ${grandTotal.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    ]
                )
            ),
            pw.SizedBox(height: 20),

            ...grouped.entries.map((entry) {
              final customer = fp.customerById(entry.key);
              final loans = entry.value;
              // 👈 FIX: Changed principalAmount to amountGiven
              final custTotal = loans.fold(0.0, (s, l) => s + l.amountGiven);

              return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${customer?.fullName ?? 'Unknown'} (Ph: ${customer?.mobile ?? '-'})',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        pw.Divider(color: PdfColors.grey400),
                        ...loans.map((l) => pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  // 👈 FIX: Changed startDate to loanDate, principalAmount to amountGiven
                                  pw.Text('  Date: ${l.loanDate}', style: const pw.TextStyle(fontSize: 12)),
                                  pw.Text('Rs. ${l.amountGiven.toStringAsFixed(0)}', style: const pw.TextStyle(fontSize: 12)),
                                ]
                            )
                        )),
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 4),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text('Subtotal: Rs. ${custTotal.toStringAsFixed(0)}',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.blueGrey800)),
                                ]
                            )
                        )
                      ]
                  )
              );
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Erramala_Loans_$monthStr.pdf',
    );
  }
}