import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/driver_status.dart';
import '../../../core/enums/vehicle_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../drivers/presentation/driver_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';
import '../domain/transport_model.dart';
import 'transport_view_model.dart';

class ReassignDialog extends ConsumerStatefulWidget {
  final Transport transport;

  const ReassignDialog({super.key, required this.transport});

  @override
  ConsumerState<ReassignDialog> createState() => _ReassignDialogState();
}

class _ReassignDialogState extends ConsumerState<ReassignDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedVehicleId;
  String? _selectedDriverId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleViewModelProvider);
    final driverState = ref.watch(driverViewModelProvider);

    final availableVehicles = vehicleState.vehicles
        .where((v) =>
            v.status == VehicleStatus.available &&
            v.canCarry(widget.transport.containerSize.code))
        .toList();

    final availableDrivers = driverState.drivers
        .where((d) => d.status == DriverStatus.available)
        .toList();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Reassign Fleet / Crew', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Vehicle / Truck', icon: Icon(Icons.local_shipping, size: 18)),
                Tab(text: 'Driver', icon: Icon(Icons.person, size: 18)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Vehicle selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available vehicles for ${widget.transport.containerSize.label}:',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: availableVehicles.isEmpty
                            ? Center(
                                child: Text(
                                  'No available vehicles matching ${widget.transport.containerSize.label} capacity',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.separated(
                                itemCount: availableVehicles.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (ctx, i) {
                                  final v = availableVehicles[i];
                                  final isSelected = v.id == _selectedVehicleId;
                                  return ListTile(
                                    selected: isSelected,
                                    title: Text(v.vehicleNumber, style: AppTextStyles.labelLarge),
                                    subtitle: Text('${v.vehicleType} • Capacity: ${v.capacity}', style: AppTextStyles.bodySmall),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle, color: AppColors.accent)
                                        : null,
                                    onTap: () => setState(() => _selectedVehicleId = v.id),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Reassign Vehicle',
                          onPressed: _selectedVehicleId == null
                              ? null
                              : () {
                                  ref.read(transportViewModelProvider.notifier).reassignVehicle(
                                        widget.transport.id,
                                        _selectedVehicleId!,
                                      );
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vehicle reassigned successfully'),
                                      backgroundColor: AppColors.green,
                                    ),
                                  );
                                },
                        ),
                      ),
                    ],
                  ),

                  // Tab 2: Driver selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available active drivers on duty:',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: availableDrivers.isEmpty
                            ? Center(
                                child: Text(
                                  'No available drivers currently on duty',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                                ),
                              )
                            : ListView.separated(
                                itemCount: availableDrivers.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (ctx, i) {
                                  final d = availableDrivers[i];
                                  final isSelected = d.id == _selectedDriverId;
                                  return ListTile(
                                    selected: isSelected,
                                    title: Text(d.name, style: AppTextStyles.labelLarge),
                                    subtitle: Text('Contact: ${d.mobileNumber}', style: AppTextStyles.bodySmall),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle, color: AppColors.accent)
                                        : null,
                                    onTap: () => setState(() => _selectedDriverId = d.id),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Reassign Driver',
                          onPressed: _selectedDriverId == null
                              ? null
                              : () {
                                  ref.read(transportViewModelProvider.notifier).reassignDriver(
                                        widget.transport.id,
                                        _selectedDriverId!,
                                      );
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Driver reassigned successfully'),
                                      backgroundColor: AppColors.green,
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
          ],
        ),
      ),
    );
  }
}
