import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/shipping_line_model.dart';

class ShippingLineDialog extends StatefulWidget {
  final ShippingLine? initialItem;
  final void Function(String name, String code) onSave;

  const ShippingLineDialog({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<ShippingLineDialog> createState() => _ShippingLineDialogState();
}

class _ShippingLineDialogState extends State<ShippingLineDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _codeController = TextEditingController(text: widget.initialItem?.code ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim(), _codeController.text.trim().toUpperCase());
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
                isEdit ? 'Edit Shipping Line' : 'Add Shipping Line',
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
            label: 'Shipping Line Name',
            hint: 'e.g. Maersk, MSC, CMA CGM',
            controller: _nameController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Shipping line name is required';
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Line Code / Prefix',
            hint: 'e.g. MAEU, MSCU',
            controller: _codeController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Code prefix is required';
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
                text: isEdit ? 'Update Line' : 'Save Line',
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
