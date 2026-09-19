import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import 'reports_view_model.dart';

import 'dart:io';
import '../data/report_export_service.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleExport(String format) async {
    final exportService = ref.read(reportExportServiceProvider);
    final filter = ref.read(reportFilterProvider);

    String title;
    List<String> headers;
    List<List<dynamic>> excelRows;
    List<List<String>> pdfRows;
    String filenamePrefix;

    final dateRangeText = filter.startDate != null
        ? 'Date Range: ${DateFormatter.formatDate(filter.startDate!)} - ${filter.endDate != null ? DateFormatter.formatDate(filter.endDate!) : "Present"}'
        : 'Filtered Historical Records';

    switch (_tabController.index) {
      case 0:
        title = 'Daily Transport Operations Report';
        filenamePrefix = 'daily_transports';
        final items = ref.read(dailyTransportReportProvider);
        headers = [
          'Date',
          'Transport ID',
          'Booking #',
          'Container #',
          'Customer',
          'Vehicle',
          'Driver',
          'From',
          'To',
          'Status'
        ];
        excelRows = items.map((i) => [
          DateFormatter.formatDate(i.date),
          i.transportId,
          i.bookingNumber,
          i.containerNumber,
          i.customer,
          i.vehicle,
          i.driver,
          i.fromLocation,
          i.toLocation,
          i.status.label,
        ]).toList();
        pdfRows = items.map((i) => [
          DateFormatter.formatDate(i.date),
          i.transportId,
          i.bookingNumber,
          i.containerNumber,
          i.customer,
          i.vehicle,
          i.driver,
          i.fromLocation,
          i.toLocation,
          i.status.label,
        ]).toList();
        break;

      case 1:
        title = 'Trip Operations Report';
        filenamePrefix = 'trips_report';
        final items = ref.read(tripReportProvider);
        headers = ['Transport ID', 'Vehicle', 'Driver', 'Route', 'Start Date', 'Completed Date', 'Status'];
        excelRows = items.map((i) => [
          i.transportId,
          i.vehicle,
          i.driver,
          i.route,
          DateFormatter.formatDate(i.startDate),
          i.completionDate != null ? DateFormatter.formatDate(i.completionDate!) : '-',
          i.status.label,
        ]).toList();
        pdfRows = items.map((i) => [
          i.transportId,
          i.vehicle,
          i.driver,
          i.route,
          DateFormatter.formatDate(i.startDate),
          i.completionDate != null ? DateFormatter.formatDate(i.completionDate!) : '-',
          i.status.label,
        ]).toList();
        break;

      case 2:
        title = 'Vehicle Utilization Report';
        filenamePrefix = 'vehicle_utilization';
        final items = ref.read(vehicleReportProvider);
        headers = ['Vehicle Number', 'Type', 'Capacity', 'Total Trips', 'Active Trips', 'Completed Trips', 'Cancelled Trips', 'Status'];
        excelRows = items.map((i) => [
          i.vehicleNumber,
          i.vehicleType,
          i.capacity,
          i.totalTrips,
          i.activeTrips,
          i.completedTrips,
          i.cancelledTrips,
          i.currentStatus.label,
        ]).toList();
        pdfRows = items.map((i) => [
          i.vehicleNumber,
          i.vehicleType,
          i.capacity,
          i.totalTrips.toString(),
          i.activeTrips.toString(),
          i.completedTrips.toString(),
          i.cancelledTrips.toString(),
          i.currentStatus.label,
        ]).toList();
        break;

      case 3:
      default:
        title = 'Customer Volume Summary Report';
        filenamePrefix = 'customer_summary';
        final items = ref.read(customerReportProvider);
        headers = ['Customer Name', 'Mobile Number', 'Total Trips', 'Completed Trips', 'Pending Trips', 'Cancelled Trips'];
        excelRows = items.map((i) => [
          i.customerName,
          i.mobileNumber,
          i.totalTrips,
          i.completedTrips,
          i.pendingTrips,
          i.cancelledTrips,
        ]).toList();
        pdfRows = items.map((i) => [
          i.customerName,
          i.mobileNumber,
          i.totalTrips.toString(),
          i.completedTrips.toString(),
          i.pendingTrips.toString(),
          i.cancelledTrips.toString(),
        ]).toList();
        break;
    }

    if (excelRows.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No records match current filters to export.'),
            backgroundColor: AppColors.amber,
          ),
        );
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text('Generating $format report...'),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      File file;
      if (format.toLowerCase().contains('excel') || format.toLowerCase().contains('xlsx')) {
        file = await exportService.exportToExcel(
          title: title,
          headers: headers,
          rows: excelRows,
          filenamePrefix: filenamePrefix,
        );
      } else {
        file = await exportService.exportToPdf(
          title: title,
          subtitle: dateRangeText,
          headers: headers,
          rows: pdfRows,
          filenamePrefix: filenamePrefix,
        );
      }

      if (mounted) {
        await exportService.showExportResultSheet(
          context: context,
          file: file,
          title: title,
          formatName: format,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate export: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(reportFilterProvider);
    final notifier = ref.read(reportFilterProvider.notifier);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Reports & Business Analytics',
                subtitle: 'Operational logs, vehicle utilization metrics, and client volume statements',
                actions: [
                  AppButton(
                    text: 'Export Excel',
                    icon: Icons.table_view_outlined,
                    variant: AppButtonVariant.outline,
                    onPressed: () => _handleExport('Excel (.xlsx)'),
                  ),
                  AppButton(
                    text: 'Export PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _handleExport('PDF Document'),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Analytics & Reports', style: AppTextStyles.headingMedium, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Exportable operational logs', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.download, size: 18, color: AppColors.accent),
                      ),
                      tooltip: 'Export Report',
                      onSelected: (val) => _handleExport(val),
                      itemBuilder: (ctx) => const [
                        PopupMenuItem(value: 'Excel (.xlsx)', child: Text('Export as Excel (.xlsx)')),
                        PopupMenuItem(value: 'PDF Document', child: Text('Export as PDF')),
                      ],
                    ),
                  ],
                ),
              ),

            // Tab bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.accent,
                tabs: const [
                  Tab(text: 'Daily Transport'),
                  Tab(text: 'Trips Report'),
                  Tab(text: 'Vehicle Utilization'),
                  Tab(text: 'Customer Summary'),
                ],
                onTap: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search report data...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => notifier.setSearchQuery(''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content
            AnimatedBuilder(
              animation: _tabController,
              builder: (ctx, _) {
                switch (_tabController.index) {
                  case 0:
                    return _buildDailyReport();
                  case 1:
                    return _buildTripReport();
                  case 2:
                    return _buildVehicleReport();
                  case 3:
                    return _buildCustomerReport();
                  default:
                    return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _buildDailyReport() {
    final items = ref.watch(dailyTransportReportProvider);
    if (items.isEmpty) return const EmptyState(title: 'No Report Records', message: 'No entries match your filters.');

    return AppCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
            columns: const [
              DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Transport ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Booking No', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Container No', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('From', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('To', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: items.map((t) {
              return DataRow(
                cells: [
                  DataCell(Text(DateFormatter.formatShortDate(t.date))),
                  DataCell(Text(t.transportId, style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent))),
                  DataCell(Text(t.bookingNumber)),
                  DataCell(Text(t.containerNumber.isNotEmpty ? t.containerNumber : '—', style: AppTextStyles.codeMono)),
                  DataCell(Text(t.customer)),
                  DataCell(Text(t.vehicle)),
                  DataCell(Text(t.driver)),
                  DataCell(Text(t.fromLocation)),
                  DataCell(Text(t.toLocation)),
                  DataCell(StatusBadge.fromTransport(t.status)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTripReport() {
    final items = ref.watch(tripReportProvider);
    if (items.isEmpty) return const EmptyState(title: 'No Trip Records', message: 'No entries match your filters.');

    return AppCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
            columns: const [
              DataColumn(label: Text('Transport ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Route', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Completion Date', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: items.map((t) {
              return DataRow(
                cells: [
                  DataCell(Text(t.transportId, style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent))),
                  DataCell(Text(t.vehicle)),
                  DataCell(Text(t.driver)),
                  DataCell(Text(t.route)),
                  DataCell(Text(DateFormatter.formatDateTime(t.startDate))),
                  DataCell(Text(DateFormatter.formatDateTime(t.completionDate))),
                  DataCell(StatusBadge.fromTransport(t.status)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleReport() {
    final items = ref.watch(vehicleReportProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    if (items.isEmpty) return const EmptyState(title: 'No Vehicle Records', message: 'No entries match your filters.');

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final v = items[i];
          return AppCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(v.vehicleNumber, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                    StatusBadge.fromVehicle(v.currentStatus),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${v.vehicleType} • ${v.capacity}', style: AppTextStyles.bodySmall),
                const Divider(height: 16),
                Row(
                  children: [
                    _buildMetricBadge('Total', '${v.totalTrips}', AppColors.blue),
                    const SizedBox(width: 8),
                    _buildMetricBadge('Active', '${v.activeTrips}', AppColors.amber),
                    const SizedBox(width: 8),
                    _buildMetricBadge('Done', '${v.completedTrips}', AppColors.green),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
            columns: const [
              DataColumn(label: Text('Vehicle Number', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Total Trips', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Active Trips', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Completed Trips', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Cancelled Trips', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Current Status', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: items.map((v) {
              return DataRow(
                cells: [
                  DataCell(Text(v.vehicleNumber, style: AppTextStyles.labelLarge)),
                  DataCell(Text(v.vehicleType)),
                  DataCell(Text(v.capacity)),
                  DataCell(Text('${v.totalTrips}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('${v.activeTrips}', style: const TextStyle(color: AppColors.accent))),
                  DataCell(Text('${v.completedTrips}', style: const TextStyle(color: AppColors.green))),
                  DataCell(Text('${v.cancelledTrips}', style: const TextStyle(color: AppColors.red))),
                  DataCell(StatusBadge.fromVehicle(v.currentStatus)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerReport() {
    final items = ref.watch(customerReportProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    if (items.isEmpty) return const EmptyState(title: 'No Customer Records', message: 'No entries match your filters.');

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final c = items[i];
          return AppCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.customerName, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Mobile: ${c.mobileNumber}', style: AppTextStyles.bodySmall),
                const Divider(height: 16),
                Row(
                  children: [
                    _buildMetricBadge('Bookings', '${c.totalTrips}', AppColors.blue),
                    const SizedBox(width: 8),
                    _buildMetricBadge('Active', '${c.pendingTrips}', AppColors.amber),
                    const SizedBox(width: 8),
                    _buildMetricBadge('Completed', '${c.completedTrips}', AppColors.green),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
            columns: const [
              DataColumn(label: Text('Customer / Party', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Contact Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Total Bookings', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Completed', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Pending / Active', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Cancelled', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: items.map((c) {
              return DataRow(
                cells: [
                  DataCell(Text(c.customerName, style: AppTextStyles.labelLarge)),
                  DataCell(Text(c.mobileNumber)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)),
                      child: Text('${c.totalTrips}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                    ),
                  ),
                  DataCell(Text('${c.completedTrips}', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold))),
                  DataCell(Text('${c.pendingTrips}', style: const TextStyle(color: AppColors.amber, fontWeight: FontWeight.bold))),
                  DataCell(Text('${c.cancelledTrips}', style: const TextStyle(color: AppColors.red))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
