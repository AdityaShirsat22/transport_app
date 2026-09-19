import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';

class ReportExportService {
  Future<Directory> _getReportsDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final reportsDir = Directory(p.join(docsDir.path, 'reports'));
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }
    return reportsDir;
  }

  /// Export tabular report data to Microsoft Excel (.xlsx)
  Future<File> exportToExcel({
    required String title,
    required List<String> headers,
    required List<List<dynamic>> rows,
    String? filenamePrefix,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = title.replaceAll(RegExp(r'[\\/?*\[\]]'), '').trim();
    final cleanSheetName = sheetName.length > 30 ? sheetName.substring(0, 30) : sheetName;

    // Use default sheet or create named sheet
    final sheet = excel[cleanSheetName];
    if (excel.getDefaultSheet() != null && excel.getDefaultSheet() != cleanSheetName) {
      excel.delete(excel.getDefaultSheet()!);
    }

    // 1. Add Headers with Professional Styling
    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue400,
        fontColorHex: ExcelColor.white,
      );
    }

    // 2. Add Data Rows
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < rows[r].length; c++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1));
        final val = rows[r][c];
        if (val == null) {
          cell.value = TextCellValue('-');
        } else if (val is int) {
          cell.value = IntCellValue(val);
        } else if (val is double) {
          cell.value = DoubleCellValue(val);
        } else if (val is bool) {
          cell.value = BoolCellValue(val);
        } else if (val is DateTime) {
          cell.value = TextCellValue(DateFormatter.formatDateTime(val));
        } else {
          cell.value = TextCellValue(val.toString());
        }
      }
    }

    // 3. Save File
    final dir = await _getReportsDirectory();
    final prefix = filenamePrefix ?? title.toLowerCase().replaceAll(' ', '_');
    final filename = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(p.join(dir.path, filename));

    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return file;
  }

  /// Export tabular report data to high-resolution multi-page PDF document
  Future<File> exportToPdf({
    required String title,
    required String subtitle,
    required List<String> headers,
    required List<List<String>> rows,
    String? filenamePrefix,
  }) async {
    final pdf = pw.Document();
    final generatedTime = DateFormatter.formatDateTime(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TRANSLOGIX FLEET OPERATIONS',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF1E3A8A),
                        ),
                      ),
                      pw.Text(
                        title.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF0F172A),
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        pw.Text(
                          subtitle,
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                        ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Generated: $generatedTime', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                      pw.Text('Total Records: ${rows.length}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 6),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Confidential | Internal Logistics Analytics', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
                pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              ],
            ),
          );
        },
        build: (pw.Context context) => [
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: rows,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E3A8A)),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
            ),
            oddRowDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF8FAFC),
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
            ),
            cellStyle: const pw.TextStyle(fontSize: 7.5),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          ),
        ],
      ),
    );

    final dir = await _getReportsDirectory();
    final prefix = filenamePrefix ?? title.toLowerCase().replaceAll(' ', '_');
    final filename = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(p.join(dir.path, filename));

    final bytes = await pdf.save();
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Open or Share exported document with interactive bottom sheet
  Future<void> showExportResultSheet({
    required BuildContext context,
    required File file,
    required String title,
    required String formatName,
  }) async {
    final sizeKb = (await file.length() / 1024).toStringAsFixed(1);
    final filename = p.basename(file.path);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: AppColors.green, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Export Generated', style: AppTextStyles.headingSmall),
                          Text('$formatName • $sizeKb KB', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      formatName.contains('PDF') ? Icons.picture_as_pdf : Icons.table_chart,
                      color: formatName.contains('PDF') ? AppColors.red : AppColors.green,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filename, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(
                            file.path,
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Open File'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.of(sheetCtx).pop();
                        final result = await OpenFilex.open(file.path);
                        if (result.type != ResultType.done && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open file: ${result.message}')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.of(sheetCtx).pop();
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile(file.path)],
                            text: 'Translogix Report: $title',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final reportExportServiceProvider = Provider<ReportExportService>((ref) {
  return ReportExportService();
});
