import 'package:flutter/material.dart';
import '../../../core/enums/port_cfs_type.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/port_cfs_model.dart';

class PortCfsDialog extends StatefulWidget {
  final PortCfs? initialItem;
  final void Function(String name, PortCfsType type, String location) onSave;

  const PortCfsDialog({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<PortCfsDialog> createState() => _PortCfsDialogState();
}

class _PortCfsDialogState extends State<PortCfsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late PortCfsType _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _locationController = TextEditingController(text: widget.initialItem?.location ?? '');
    _type = widget.initialItem?.type ?? PortCfsType.cfs;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _type,
        _locationController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
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
                isEdit ? 'Edit Port / CFS' : 'Add Port / CFS',
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
            label: 'Facility Name',
            hint: 'e.g. JNPT Terminal 4, Allcargo CFS',
            controller: _nameController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Facility name is required';
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<PortCfsType>(
            label: 'Facility Category',
            value: _type,
            items: PortCfsType.values
                .map((t) => AppDropdownItem(value: t, label: t.label))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _type = val);
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Location / City',
            hint: 'e.g. Navi Mumbai, Maharashtra',
            controller: _locationController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Location is required';
              return null;
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
                text: isEdit ? 'Update Facility' : 'Save Facility',
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
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: formContent,
        ),
      ),
    );
  }
}
