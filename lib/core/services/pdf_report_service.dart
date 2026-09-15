import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/investment.dart';
import '../models/investment_analysis.dart';
import 'currency_formatter.dart';

/// Generates the branded Final Report PDF (RDP section 23 - PDF Reports).
/// Kept off the UI thread by using the `printing` package's async layout,
/// so PDF generation does not freeze the UI (RDP section 26).
class PdfReportService {
  const PdfReportService._();

  static Future<File> generate(Investment inv, InvestmentAnalysis analysis) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Property Investment Report',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('${inv.name} - ${inv.location}'),
            pw.Divider(),
            pw.SizedBox(height: 12),
            _kv('Purchase Price', CurrencyFormatter.format(inv.purchasePrice, currency: inv.currency)),
            _kv('Total Investment', CurrencyFormatter.format(analysis.totalInvestment, currency: inv.currency)),
            _kv('Gross Yield', CurrencyFormatter.percent(analysis.grossYieldPercent)),
            _kv('Net Yield', CurrencyFormatter.percent(analysis.netYieldPercent)),
            _kv('Monthly Cash Flow', CurrencyFormatter.format(analysis.monthlyCashFlow, currency: inv.currency)),
            _kv('ROI (Annual)', CurrencyFormatter.percent(analysis.roiPercent)),
            _kv('Break-even Period', '${analysis.breakEvenYears.toStringAsFixed(1)} years'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Disclaimer: Results are estimates/projections only and do not '
              'constitute financial advice.',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${inv.name}_report.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  static Future<void> share(File file) => Printing.sharePdf(
        bytes: file.readAsBytesSync(),
        filename: file.uri.pathSegments.last,
      );

  static pw.Widget _kv(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [pw.Text(label), pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))],
        ),
      );
}
