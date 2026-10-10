import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'customer_loan_modules.dart';

class BondPdfService {
  static Future<void> generateAndShareBond(Customer customer) async {
    final pdf = pw.Document();

    // 1. Fetch Telugu Font dynamically from Google Fonts
    final teluguFont = await PdfGoogleFonts.notoSansTeluguRegular();

    // 2. Load the App Logo for the Watermark
    final logoData = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // 3. Define the rules
    const englishRules = '''
1. Repayment Schedule: The borrower agrees to repay all loan amounts disbursed strictly as per the agreed daily or weekly schedule without any delay.
2. Late Payment Penalty: Payments must be made on time. In the event of a delayed payment, a penalty of 2% of the pending amount will be charged per day starting from the day after the due date until the dues are completely cleared.
3. Field Collection Consent: The borrower provides explicit consent for Erramala Finance representatives to conduct field collections at their residential address.
4. Guarantor Liability: The guarantor assumes full responsibility for the outstanding balances in the event the borrower fails to repay.
''';

    const teluguRules = '''
1. వాయిదాల చెల్లింపు: తీసుకున్న అప్పును ఎలాంటి ఆలస్యం లేకుండా అంగీకరించిన విధంగా (రోజువారీ లేదా వారపు) వాయిదాలలో చెల్లించడానికి రుణగ్రహీత అంగీకరిస్తున్నారు.
2. ఆలస్యపు రుసుము: వాయిదాలు సమయానికి కట్టాలి. ఒకవేళ చెల్లింపు ఆలస్యమైతే, మరుసటి రోజు నుండి బాకీ మొత్తం చెల్లించే వరకు, ఆ పెండింగ్ మొత్తంపై ప్రతిరోజూ 2% పెనాల్టీ వసూలు చేయబడుతుంది.
3. వసూలు అనుమతి: ఎర్రమల ఫైనాన్స్ సిబ్బంది నేరుగా ఇంటి వద్దకు వచ్చి వాయిదాలు వసూలు చేసుకోవడానికి రుణగ్రహీత పూర్తి అనుమతి ఇస్తున్నారు.
4. గ్యారంటర్ బాధ్యత: ఒకవేళ రుణగ్రహీత అప్పు కట్టకపొతే, ఆ బాకీ ఉన్న మొత్తానికి గ్యారంటర్ పూర్తి బాధ్యత వహించాల్సి ఉంటుంది.
''';

    // 4. Build the PDF page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              // ── BACKGROUND WATERMARK LOGO ──
              pw.Opacity(
                opacity: 0.08,
                child: pw.Image(logoImage, width: 350),
              ),

              // ── FOREGROUND CONTENT ──
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey900, width: 2),
                ),
                padding: const pw.EdgeInsets.all(24),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ── HEADER ──
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text('ERRAMALA FINANCE',
                              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                          pw.SizedBox(height: 4),
                          pw.Text('MASTER LOAN AGREEMENT / ప్రధాన ఋణ ఒప్పంద పత్రము',
                              style: pw.TextStyle(font: teluguFont, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 8),
                          pw.Container(height: 1, width: 300, color: PdfColors.grey500),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 24),

                    // ── PARTIES INFO ──
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Lender Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                                    pw.Text('Erramala Finance'),
                                    pw.Text('Owner: Sohan Thammineni'),
                                  ]
                              )
                          ),
                          pw.Expanded(
                              child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Borrower Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                                    pw.Text('Name: ${customer.fullName}'),
                                    pw.Text('Mobile: ${customer.mobile}'),
                                    pw.Text('Address: ${customer.village ?? ''} ${customer.city ?? ''}'),
                                    if (customer.guarantorName != null && customer.guarantorName!.isNotEmpty) ...[
                                      pw.SizedBox(height: 10),
                                      pw.Text('Guarantor Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                                      pw.Text('Name: ${customer.guarantorName}'),
                                      pw.Text('Mobile: ${customer.guarantorMobile ?? ''}'),
                                    ]
                                  ]
                              )
                          ),
                        ]
                    ),
                    pw.SizedBox(height: 24),
                    pw.Divider(color: PdfColors.grey300),
                    pw.SizedBox(height: 12),

                    // ── RULES & TERMS ──
                    pw.Text('Terms and Conditions:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.SizedBox(height: 8),
                    pw.Text(englishRules, style: const pw.TextStyle(fontSize: 11, lineSpacing: 2)),
                    pw.SizedBox(height: 12),

                    pw.Text('నియమ నిబంధనలు:', style: pw.TextStyle(font: teluguFont, fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.SizedBox(height: 8),
                    pw.Text(teluguRules, style: pw.TextStyle(font: teluguFont, fontSize: 11, lineSpacing: 2)),
                    pw.Spacer(),

                    // ── CHECKBOX & DECLARATION ──
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(width: 14, height: 14, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black))),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: pw.Text(
                              // ✨ UPDATED: Simpler declaration text
                              'I have read and agree to the terms and conditions. / నేను పై నియమ నిబంధనలు చదివి అంగీకరిస్తున్నాను.',
                              style: pw.TextStyle(font: teluguFont, fontSize: 11),
                            ),
                          ),
                        ]
                    ),
                    pw.SizedBox(height: 40),

                    // ── SIGNATURES ──
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(width: 120, height: 1, color: PdfColors.black),
                                pw.SizedBox(height: 4),
                                pw.Text('Borrower Signature', style: const pw.TextStyle(fontSize: 10)),
                                pw.Text('(కస్టమర్ సంతకం)', style: pw.TextStyle(font: teluguFont, fontSize: 10)),
                              ]
                          ),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(width: 150, height: 1, color: PdfColors.black),
                                pw.SizedBox(height: 4),
                                pw.Text('Authorized Signatory', style: const pw.TextStyle(fontSize: 10)),
                                pw.Text('(Erramala Finance)', style: const pw.TextStyle(fontSize: 10)),
                              ]
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // 5. Share the PDF
    final String cleanName = customer.fullName.replaceAll(' ', '_');
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Erramala_Master_Bond_$cleanName.pdf',
    );
  }
}