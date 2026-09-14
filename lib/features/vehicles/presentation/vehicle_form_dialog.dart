import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/enums/vehicle_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/vehicle_model.dart';

class VehicleFormDialog extends StatefulWidget {
  final Vehicle? initialVehicle;
  final void Function(
    String vehicleNumber,
    String vehicleType,
    String capacity,
    VehicleStatus status,
  ) onSave;

  const VehicleFormDialog({
    super.key,
    this.initialVehicle,
    required this.onSave,
  });

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberController;
  late String _vehicleType;
  late String _capacity;
  late VehicleStatus _status;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.initialVehicle?.vehicleNumber ?? '');
    _vehicleType = widget.initialVehicle?.vehicleType ?? AppConstants.vehicleTypes.first;
    _capacity = widget.initialVehicle?.capacity ?? AppConstants.capacityTypes.last; // '40 FT'
    _status = widget.initialVehicle?.status ?? VehicleStatus.available;
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _numberController.text.trim().toUpperCase(),
        _vehicleType,
        _capacity,
        _status,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialVehicle != null;
    final isMobile = ResponsiveLayout.isMobile(context);

    final formContent = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? 'Edit Vehicle' : 'Add New Vehicle',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Vehicle Number',
            hint: 'e.g. MH12AB1234',
            controller: _numberController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Vehicle number is required';
              }
              if (val.trim().length < 6) {
                return 'Enter a valid registration number';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<String>(
            label: 'Vehicle Type',
            value: _vehicleType,
            items: AppConstants.vehicleTypes
                .map((t) => AppDropdownItem(value: t, label: t))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _vehicleType = val);
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<String>(
            label: 'Capacity',
            value: _capacity,
            items: AppConstants.capacityTypes
                .map((c) => AppDropdownItem(value: c, label: c))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _capacity = val);
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<VehicleStatus>(
            label: 'Operational Status',
            value: _status,
            items: VehicleStatus.values
                .map((s) => AppDropdownItem(value: s, label: s.label))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              AppButton(
                text: isEdit ? 'Save Changes' : 'Create Vehicle',
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(child: formContent),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: formContent,
        ),
      ),
    );
  }
}
