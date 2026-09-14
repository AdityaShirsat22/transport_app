import 'package:flutter/material.dart';
import '../../../core/enums/driver_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/driver_model.dart';

class DriverFormDialog extends StatefulWidget {
  final Driver? initialDriver;
  final void Function(String name, String mobile, DriverStatus status) onSave;

  const DriverFormDialog({
    super.key,
    this.initialDriver,
    required this.onSave,
  });

  @override
  State<DriverFormDialog> createState() => _DriverFormDialogState();
}

class _DriverFormDialogState extends State<DriverFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late DriverStatus _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDriver?.name ?? '');
    _mobileController = TextEditingController(text: widget.initialDriver?.mobileNumber ?? '');
    _status = widget.initialDriver?.status ?? DriverStatus.available;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _mobileController.text.trim(),
        _status,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialDriver != null;
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
                isEdit ? 'Edit Driver' : 'Add New Driver',
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
            label: 'Driver Full Name',
            hint: 'e.g. Ramesh Patel',
            controller: _nameController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Driver name is required';
              }
              if (val.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Mobile Number',
            hint: 'e.g. 9876543210',
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Mobile number is required';
              }
              final clean = val.trim().replaceAll(RegExp(r'[\s-]'), '');
              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) {
                return 'Enter valid 10-digit Indian mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<DriverStatus>(
            label: 'Duty Status',
            value: _status,
            items: DriverStatus.values
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
                text: isEdit ? 'Save Changes' : 'Register Driver',
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
