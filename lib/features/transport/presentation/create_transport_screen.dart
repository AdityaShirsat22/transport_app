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
import '../../locations/presentation/location_view_model.dart';
import '../../parties/presentation/party_view_model.dart';
import '../../ports_cfs/presentation/port_cfs_view_model.dart';
import '../../shipping_lines/presentation/shipping_line_view_model.dart';
import 'assignment_dialog.dart';
import 'transport_view_model.dart';

class CreateTransportScreen extends ConsumerStatefulWidget {
  const CreateTransportScreen({super.key});

  @override
  ConsumerState<CreateTransportScreen> createState() => _CreateTransportScreenState();
}

class _CreateTransportScreenState extends ConsumerState<CreateTransportScreen> {
  final _formKey = GlobalKey<FormState>();

  // Section 1: Container Details
  ContainerSize _containerSize = ContainerSize.size40Ft;
  ShipmentType _shipmentType = ShipmentType.export;
  final _containerNumberCtrl = TextEditingController(text: 'MSCU5512349');
  final _sealNumberCtrl = TextEditingController(text: 'SL-78901');

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

    setState(() => _isSubmitting = true);

    try {
      final outcome = await ref.read(transportViewModelProvider.notifier).createBooking(
            containerSize: _containerSize,
            shipmentType: _shipmentType,
            containerNumber: _containerNumberCtrl.text.trim().toUpperCase(),
            sealNumber: _sealNumberCtrl.text.trim().toUpperCase(),
            partyId: _partyId!,
            partyName: _partyName!,
            partyMobile: _partyMobile ?? '9820011223',
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
          );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final isMobile = ResponsiveLayout.isMobile(context);
      if (isMobile) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (sheetCtx) => AssignmentProgressDialog(
            transport: outcome.transport,
            wasAssigned: outcome.wasAssigned,
            failureReason: outcome.failureReason,
            notificationLog: outcome.notificationLog,
            onViewDetails: () {
              Navigator.of(sheetCtx).pop();
              context.go('/transport/${outcome.transport.id}');
            },
          ),
        );
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) => AssignmentProgressDialog(
            transport: outcome.transport,
            wasAssigned: outcome.wasAssigned,
            failureReason: outcome.failureReason,
            notificationLog: outcome.notificationLog,
            onViewDetails: () {
              Navigator.of(dialogCtx).pop();
              context.go('/transport/${outcome.transport.id}');
            },
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final parties = ref.watch(partyViewModelProvider).parties;
    final shippingLines = ref.watch(shippingLineViewModelProvider).shippingLines;
    final locations = ref.watch(locationViewModelProvider).locations;
    final portCfsList = ref.watch(portCfsViewModelProvider).items;
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
          child: AppButton(
            text: isMobile ? 'CREATE & AUTO-ASSIGN' : 'CREATE BOOKING & AUTO-ASSIGN',
            icon: Icons.check,
            height: 48,
            isLoading: _isSubmitting,
            onPressed: _handleCreateBooking,
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
              // Notice Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_mode, color: AppColors.accent, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Deterministic Auto-Assignment: The system automatically matches an available vehicle & driver based on container size.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 1 — Container Details
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Section 1 — Container Details', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Specify container specifications and custom seals', style: AppTextStyles.bodySmall),
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
                    AppTextField(
                      label: 'Container Number',
                      hint: 'e.g. MSCU1234567',
                      controller: _containerNumberCtrl,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Container number is required';
                        }
                        if (val.trim().length < 8) {
                          return 'Standard container format required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Custom Seal Number',
                      hint: 'e.g. SL-98234',
                      controller: _sealNumberCtrl,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Seal number is required';
                        }
                        return null;
                      },
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
