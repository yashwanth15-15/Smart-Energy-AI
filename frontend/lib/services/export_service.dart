import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:frontend/models/analytics_model.dart';
import 'package:intl/intl.dart';

class ExportService {
  static Future<void> generateAndPrintPdf(AnalyticsData data) async {
    final pdf = pw.Document();

    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    final now = formatter.format(DateTime.now());

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
                  pw.Text('Smart Energy AI', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.Text('Analytics Report', style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Generated: $now', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            pw.SizedBox(height: 20),
            
            // KPIs
            pw.Text('Key Performance Indicators', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.SizedBox(height: 10),
            
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              headers: ['Metric', 'Value'],
              data: [
                ['Today\'s Total Energy', '${data.todayTotalEnergy.toStringAsFixed(1)} kWh'],
                ['Weekly Total Energy', '${data.weeklyTotalEnergy.toStringAsFixed(1)} kWh'],
                ['Today\'s Cost', '\$${data.todayCost.toStringAsFixed(2)}'],
                ['CO2 Emissions', '${data.todayCo2.toStringAsFixed(1)} kg'],
                ['Campus Average', '${data.campusAverageEnergy.toStringAsFixed(1)} kWh'],
                ['Highest Consuming Building', data.highestConsumingBuilding],
                ['Active Alerts', data.totalActiveAlerts.toString()],
              ],
            ),
            
            pw.SizedBox(height: 30),
            
            // Trends (Table format for PDF since we can't easily draw fl_chart into PDF without capturing widget as image)
            pw.Text('Energy Trend (Last 24h)', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.SizedBox(height: 10),
            
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.center,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
              headers: ['Time', 'Energy (kWh)', 'Carbon (T)'],
              data: List<List<String>>.generate(data.energyTrend.length, (index) {
                return [
                  data.energyTrend[index].timestamp,
                  data.energyTrend[index].value.toStringAsFixed(1),
                  data.carbonTrend[index].value.toStringAsFixed(1),
                ];
              }),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SmartEnergy_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
