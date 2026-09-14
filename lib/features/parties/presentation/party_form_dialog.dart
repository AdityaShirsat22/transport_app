import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/party_model.dart';

class PartyFormDialog extends StatefulWidget {
  final Party? initialParty;
  final void Function(String name, String mobile, String email, String city) onSave;

  const PartyFormDialog({
    super.key,
    this.initialParty,
    required this.onSave,
  });

  @override
  State<PartyFormDialog> createState() => _PartyFormDialogState();
}

class _PartyFormDialogState extends State<PartyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialParty?.name ?? '');
    _mobileController = TextEditingController(text: widget.initialParty?.mobileNumber ?? '');
    _emailController = TextEditingController(text: widget.initialParty?.email ?? '');
    _cityController = TextEditingController(text: widget.initialParty?.city ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _mobileController.text.trim(),
        _emailController.text.trim(),
        _cityController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialParty != null;
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
                isEdit ? 'Edit Customer Party' : 'Add New Customer Party',
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
            label: 'Company / Party Name',
            hint: 'e.g. Reliance Industries Ltd',
            controller: _nameController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Party name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Mobile Number',
            hint: 'e.g. 9820011223',
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
          AppTextField(
            label: 'Email Address',
            hint: 'e.g. logistics@client.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Email is required';
              }
              if (!val.contains('@')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'City / Location',
            hint: 'e.g. Mumbai, Maharashtra',
            controller: _cityController,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'City is required';
              }
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
                text: isEdit ? 'Save Changes' : 'Register Party',
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
