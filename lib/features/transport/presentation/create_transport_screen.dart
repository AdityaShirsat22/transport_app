import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/container_size.dart';
import '../../../core/enums/shipment_type.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/searchable_select_dialog.dart';
import '../../drivers/presentation/driver_view_model.dart';
import '../../locations/presentation/location_view_model.dart';
import '../../parties/presentation/party_view_model.dart';
import '../../ports_cfs/presentation/port_cfs_view_model.dart';
import '../../shipping_lines/presentation/shipping_line_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';
import 'transport_view_model.dart';

class CreateTransportScreen extends ConsumerStatefulWidget {
  const CreateTransportScreen({super.key});

  @override
  ConsumerState<CreateTransportScreen> createState() => _CreateTransportScreenState();
}

class _CreateTransportScreenState extends ConsumerState<CreateTransportScreen> {
  final _formKey = GlobalKey<FormState>();

  // Section 1: Container & Assignment Details
  ContainerSize _containerSize = ContainerSize.size40Ft;
  ShipmentType _shipmentType = ShipmentType.export;
  final _containerNumberCtrl = TextEditingController();
  final _sealNumberCtrl = TextEditingController();
  String? _vehicleId;
  String? _vehicleNumber;
  String? _driverId;
  String? _driverName;
  String? _driverMobile;

  // Section 2: Booking Details
  String? _partyId;
  String? _partyName;
  String? _partyMobile;
  String? _bookingPartyId;
  String? _bookingPartyName;
  String? _shippingLineId;
  String? _shippingLineName;
  final _bookingNumberCtrl = TextEditingController(text: IdGenerator.generateBookingNumber());

  // Section 3: Route Details
  String? _fromLocationId;
  String? _fromLocationName;
  String? _toLocationId;
  String? _toLocationName;
  String? _portCfsId;
  String? _portCfsName;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parties = ref.read(partyViewModelProvider).parties;
      final lines = ref.read(shippingLineViewModelProvider).shippingLines;
      final locations = ref.read(locationViewModelProvider).locations;
      final ports = ref.read(portCfsViewModelProvider).items;

      setState(() {
        if (parties.isNotEmpty) {
          _partyId = parties.first.party.id;
          _partyName = parties.first.party.name;
          _partyMobile = parties.first.party.mobileNumber;
          _bookingPartyId = parties.first.party.id;
          _bookingPartyName = parties.first.party.name;
        }
        if (lines.isNotEmpty) {
          _shippingLineId = lines.first.id;
          _shippingLineName = lines.first.name;
        }
        if (locations.isNotEmpty) {
          _fromLocationId = locations.first.id;
          _fromLocationName = locations.first.name;
          if (locations.length > 3) {
            _toLocationId = locations[3].id;
            _toLocationName = locations[3].name;
          }
        }
        if (ports.isNotEmpty) {
          _portCfsId = ports.first.id;
          _portCfsName = ports.first.name;
        }
      });
    });
  }

  @override
  void dispose() {
    _containerNumberCtrl.dispose();
    _sealNumberCtrl.dispose();
    _bookingNumberCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _containerSize = ContainerSize.size40Ft;
      _shipmentType = ShipmentType.export;
      _containerNumberCtrl.clear();
      _sealNumberCtrl.clear();
      _bookingNumberCtrl.text = IdGenerator.generateBookingNumber();
      _vehicleId = null;
      _vehicleNumber = null;
      _driverId = null;
      _driverName = null;
      _driverMobile = null;
      _partyId = null;
      _partyName = null;
      _partyMobile = null;
      _bookingPartyId = null;
      _bookingPartyName = null;
      _shippingLineId = null;
      _shippingLineName = null;
      _fromLocationId = null;
      _fromLocationName = null;
      _toLocationId = null;
      _toLocationName = null;
      _portCfsId = null;
      _portCfsName = null;
    });
  }

  Future<void> _handleCreateBooking() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the validation errors in the form'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_vehicleId == null || _driverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a Vehicle and Driver'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_partyId == null || _bookingPartyId == null || _shippingLineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Customer, Booking Party, and Shipping Line'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_fromLocationId == null || _toLocationId == null || _portCfsId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please specify origin, destination, and Port/CFS'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please review the booking details before creating:'),
            const SizedBox(height: 12),
            _confirmRow('Booking No.', _bookingNumberCtrl.text.trim().toUpperCase()),
            _confirmRow('Customer', _partyName ?? '-'),
            _confirmRow('Vehicle', _vehicleNumber ?? '-'),
            _confirmRow('Driver', _driverName ?? '-'),
            _confirmRow('Route', '${_fromLocationName ?? '-'} → ${_toLocationName ?? '-'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm & Create'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    try {
      final outcome = await ref.read(transportViewModelProvider.notifier).createBooking(
            containerSize: _containerSize,
            shipmentType: _shipmentType,
            containerNumber: _containerNumberCtrl.text.trim().toUpperCase(),
            sealNumber: _sealNumberCtrl.text.trim().toUpperCase(),
            partyId: _partyId!,
            partyName: _partyName!,
            partyMobile: _partyMobile ?? '',
            bookingPartyId: _bookingPartyId!,
            bookingPartyName: _bookingPartyName!,
            shippingLineId: _shippingLineId!,
            shippingLineName: _shippingLineName!,
            bookingNumber: _bookingNumberCtrl.text.trim().toUpperCase(),
            fromLocationId: _fromLocationId!,
            fromLocationName: _fromLocationName!,
            toLocationId: _toLocationId!,
            toLocationName: _toLocationName!,
            portCfsId: _portCfsId!,
            portCfsName: _portCfsName!,
            vehicleId: _vehicleId!,
            vehicleNumber: _vehicleNumber!,
            driverId: _driverId!,
            driverName: _driverName!,
            driverMobile: _driverMobile ?? '',
          );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      // Navigate directly to the new transport's details page
      context.go('/transport/${outcome.transport.id}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating transport: $e'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  Widget _confirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parties = ref.watch(partyViewModelProvider).parties;
    final shippingLines = ref.watch(shippingLineViewModelProvider).shippingLines;
    final locations = ref.watch(locationViewModelProvider).locations;
    final portCfsList = ref.watch(portCfsViewModelProvider).items;
    final vehicles = ref.watch(vehicleViewModelProvider).vehicles;
    final drivers = ref.watch(driverViewModelProvider).drivers;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/transport')),
        title: const Text('New Transport Booking'),
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                text: 'CREATE BOOKING',
                icon: Icons.check,
                height: 48,
                isLoading: _isSubmitting,
                onPressed: _handleCreateBooking,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _clearForm,
                  icon: const Icon(Icons.clear_all_rounded, size: 18),
                  label: const Text('CLEAR FORM'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1 — Container & Assignment Details
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Section 1 — Container & Assignment Details', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Specify container specs, assign vehicle and driver', style: AppTextStyles.bodySmall),
                    const Divider(height: 20),
                    if (isMobile) ...[
                      AppDropdown<ContainerSize>(
                        label: 'Container Size',
                        value: _containerSize,
                        isRequired: true,
                        items: ContainerSize.values
                            .map((s) => AppDropdownItem(value: s, label: s.label))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _containerSize = val);
                        },
                      ),
                      const SizedBox(height: 14),
                      AppDropdown<ShipmentType>(
                        label: 'Shipment Type',
                        value: _shipmentType,
                        isRequired: true,
                        items: ShipmentType.values
                            .map((s) => AppDropdownItem(value: s, label: s.label))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _shipmentType = val);
                        },
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdown<ContainerSize>(
                              label: 'Container Size',
                              value: _containerSize,
                              isRequired: true,
                              items: ContainerSize.values
                                  .map((s) => AppDropdownItem(value: s, label: s.label))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _containerSize = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppDropdown<ShipmentType>(
                              label: 'Shipment Type',
                              value: _shipmentType,
                              isRequired: true,
                              items: ShipmentType.values
                                  .map((s) => AppDropdownItem(value: s, label: s.label))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _shipmentType = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 14),
                    // Vehicle selector
                    SearchableSelectField<String>(
                      label: 'Vehicle',
                      hint: 'Select vehicle',
                      value: _vehicleId,
                      selectedDisplay: _vehicleNumber,
                      isRequired: true,
                      items: vehicles.map((v) {
                        return SearchableSelectItem(
                          value: v.id,
                          title: v.vehicleNumber,
                          subtitle: '${v.vehicleType} • ${v.capacity} • ${v.status.label}',
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = vehicles.firstWhere((v) => v.id == id);
                        setState(() {
                          _vehicleId = id;
                          _vehicleNumber = selected.vehicleNumber;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    // Driver selector
                    SearchableSelectField<String>(
                      label: 'Driver',
                      hint: 'Select driver',
                      value: _driverId,
                      selectedDisplay: _driverName,
                      isRequired: true,
                      items: drivers.map((d) {
                        return SearchableSelectItem(
                          value: d.id,
                          title: d.name,
                          subtitle: '${d.mobileNumber} • ${d.status.label}',
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = drivers.firstWhere((d) => d.id == id);
                        setState(() {
                          _driverId = id;
                          _driverName = selected.name;
                          _driverMobile = selected.mobileNumber;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Container Number',
                      hint: 'e.g. MSCU1234567 (Optional)',
                      controller: _containerNumberCtrl,
                      isRequired: false,
                      validator: (val) {
                        if (val != null && val.trim().isNotEmpty && val.trim().length < 4) {
                          return 'Standard container format required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Custom Seal Number',
                      hint: 'e.g. SL-98234 (Optional)',
                      controller: _sealNumberCtrl,
                      isRequired: false,
                      validator: (val) => null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 2 — Booking Details
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.assignment_outlined, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Section 2 — Booking Details', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Select billing party, booking agent, and shipping line', style: AppTextStyles.bodySmall),
                    const Divider(height: 20),
                    SearchableSelectField<String>(
                      label: 'Party / Customer Name',
                      hint: 'Select client party',
                      value: _partyId,
                      selectedDisplay: _partyName,
                      isRequired: true,
                      items: parties.map((p) {
                        return SearchableSelectItem(
                          value: p.party.id,
                          title: p.party.name,
                          subtitle: '${p.party.mobileNumber} • ${p.party.city}',
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = parties.firstWhere((p) => p.party.id == id);
                        setState(() {
                          _partyId = id;
                          _partyName = selected.party.name;
                          _partyMobile = selected.party.mobileNumber;
                          if (_bookingPartyId == null) {
                            _bookingPartyId = id;
                            _bookingPartyName = selected.party.name;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    SearchableSelectField<String>(
                      label: 'Booking Party Name',
                      hint: 'Select booking party',
                      value: _bookingPartyId,
                      selectedDisplay: _bookingPartyName,
                      isRequired: true,
                      items: parties.map((p) {
                        return SearchableSelectItem(
                          value: p.party.id,
                          title: p.party.name,
                          subtitle: p.party.city,
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = parties.firstWhere((p) => p.party.id == id);
                        setState(() {
                          _bookingPartyId = id;
                          _bookingPartyName = selected.party.name;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    SearchableSelectField<String>(
                      label: 'Shipping Line',
                      hint: 'Select shipping carrier',
                      value: _shippingLineId,
                      selectedDisplay: _shippingLineName,
                      isRequired: true,
                      items: shippingLines.map((l) {
                        return SearchableSelectItem(
                          value: l.id,
                          title: l.name,
                          subtitle: 'Prefix: ${l.code}',
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = shippingLines.firstWhere((l) => l.id == id);
                        setState(() {
                          _shippingLineId = id;
                          _shippingLineName = selected.name;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Booking Number',
                      hint: 'e.g. BK2026-8809',
                      controller: _bookingNumberCtrl,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Booking number is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3 — Route Details
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.route_outlined, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Section 3 — Route & CFS Details', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Specify origin, destination, and maritime gateway', style: AppTextStyles.bodySmall),
                    const Divider(height: 20),
                    SearchableSelectField<String>(
                      label: 'From Location',
                      hint: 'Select origin',
                      value: _fromLocationId,
                      selectedDisplay: _fromLocationName,
                      isRequired: true,
                      items: locations.map((l) {
                        return SearchableSelectItem(
                          value: l.id,
                          title: l.name,
                          subtitle: l.type.label,
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = locations.firstWhere((l) => l.id == id);
                        setState(() {
                          _fromLocationId = id;
                          _fromLocationName = selected.name;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    SearchableSelectField<String>(
                      label: 'To Location',
                      hint: 'Select destination',
                      value: _toLocationId,
                      selectedDisplay: _toLocationName,
                      isRequired: true,
                      items: locations.map((l) {
                        return SearchableSelectItem(
                          value: l.id,
                          title: l.name,
                          subtitle: l.type.label,
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = locations.firstWhere((l) => l.id == id);
                        setState(() {
                          _toLocationId = id;
                          _toLocationName = selected.name;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    SearchableSelectField<String>(
                      label: 'Port / CFS Facility',
                      hint: 'Select CFS',
                      value: _portCfsId,
                      selectedDisplay: _portCfsName,
                      isRequired: true,
                      items: portCfsList.map((p) {
                        return SearchableSelectItem(
                          value: p.id,
                          title: p.name,
                          subtitle: '${p.type.label} • ${p.location}',
                        );
                      }).toList(),
                      onSelected: (id) {
                        final selected = portCfsList.firstWhere((p) => p.id == id);
                        setState(() {
                          _portCfsId = id;
                          _portCfsName = selected.name;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
