import 'package:flutter/material.dart';
import '../../../core/enums/location_type.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/location_model.dart';

class LocationDialog extends StatefulWidget {
  final Location? initialLocation;
  final void Function(String name, LocationType type) onSave;

  const LocationDialog({
    super.key,
    this.initialLocation,
    required this.onSave,
  });

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late LocationType _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialLocation?.name ?? '');
    _type = widget.initialLocation?.type ?? LocationType.factory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim(), _type);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialLocation != null;
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
                isEdit ? 'Edit Location Hub' : 'Add Location Hub',
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
            label: 'Location Name',
            hint: 'e.g. Pune MIDC Hub, Nhava Sheva Yard',
            controller: _nameController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Location name is required';
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppDropdown<LocationType>(
            label: 'Facility Type',
            value: _type,
            items: LocationType.values
                .map((t) => AppDropdownItem(value: t, label: t.label))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _type = val);
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
                text: isEdit ? 'Update Location' : 'Save Location',
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
