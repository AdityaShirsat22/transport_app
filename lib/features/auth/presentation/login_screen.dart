import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

enum LoginRole { superAdmin, coordinator, driver }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  LoginRole _selectedRole = LoginRole.superAdmin;

  // Form controllers for Operations Login
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  // PIN controllers
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  String? _pinError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _switchRole(LoginRole role) {
    setState(() {
      _selectedRole = role;
      _pinError = null;
      _pinController.clear();
    });
  }

  Future<void> _handleOperationsLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text);

    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  Future<void> _handlePinSubmit(String pin) async {
    setState(() => _pinError = null);

    if (pin.length != 4) {
      setState(() => _pinError = 'Please enter a complete 4-digit PIN');
      return;
    }

    final roleName = switch (_selectedRole) {
      LoginRole.superAdmin => 'Super Admin',
      LoginRole.coordinator => 'Coordinator',
      LoginRole.driver => 'Driver',
    };

    final success = await ref
        .read(authProvider.notifier)
        .loginWithPin(pin: pin, role: roleName);

    if (!mounted) return;

    if (success) {
      context.go('/dashboard');
    } else {
      final authState = ref.read(authProvider);
      setState(() {
        _pinError = authState.errorMessage ?? 'Invalid PIN. Please try again.';
        _pinController.clear();
      });
      _pinFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Icon & Brand
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    AppConstants.appName,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Multi-Role Logistics & Operations Portal',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Role Selector Segmented Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      _buildRoleTab(
                        role: LoginRole.superAdmin,
                        label: 'Super Admin',
                        icon: Icons.shield_outlined,
                      ),
                      _buildRoleTab(
                        role: LoginRole.coordinator,
                        label: 'Coordinator',
                        icon: Icons.assignment_ind_outlined,
                      ),
                      _buildRoleTab(
                        role: LoginRole.driver,
                        label: 'Driver',
                        icon: Icons.badge_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Global Error Banner
                if (authState.errorMessage != null && _pinError == null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.red.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Role-Specific Content Area
                if (_selectedRole == LoginRole.superAdmin) ...[
                  _buildSuperAdminSection(authState.isLoading),
                ] else if (_selectedRole == LoginRole.coordinator) ...[
                  _buildPinLoginSection(
                    title: 'Coordinator Portal Access',
                    subtitle:
                        'Enter your 4-digit Coordinator PIN to access dispatch and fleet queue.',
                    icon: Icons.assignment_ind_outlined,
                    isLoading: authState.isLoading,
                  ),
                ] else ...[
                  _buildDriverComingSoonSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab({
    required LoginRole role,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: InkWell(
        onTap: () => _switchRole(role),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuperAdminSection(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Email Address',
            controller: _emailCtrl,
            hint: "Enter your email id",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!val.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            hint: "enter your password",
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: const Color(0xFF94A3B8),
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Sign In to Operations',
            icon: Icons.login,
            isLoading: isLoading,
            onPressed: _handleOperationsLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildPinLoginSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isLoading,
  }) {
    final defaultPinTheme = PinTheme(
      width: 58,
      height: 62,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.red, width: 2),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.accentLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 4-Digit Pinput Widget
        Center(
          child: Pinput(
            length: 4,
            controller: _pinController,
            focusNode: _pinFocusNode,
            autofocus: true,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            errorPinTheme: errorPinTheme,
            obscureText: true,
            obscuringCharacter: '●',
            showCursor: true,
            onCompleted: _handlePinSubmit,
            onChanged: (val) {
              if (_pinError != null) {
                setState(() => _pinError = null);
              }
            },
          ),
        ),
        const SizedBox(height: 12),

        // Error message under PIN
        if (_pinError != null) ...[
          Center(
            child: Text(
              _pinError!,
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],

        const SizedBox(height: 8),

        // Enter PIN Button
        AppButton(
          text: 'Sign In with PIN',
          icon: Icons.lock_open,
          isLoading: isLoading,
          onPressed: () => _handlePinSubmit(_pinController.text),
        ),
      ],
    );
  }

  Widget _buildDriverComingSoonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Center icon badge with glow
        Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Coming Soon Tag
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top, color: AppColors.amber, size: 13),
                SizedBox(width: 6),
                Text(
                  'COMING SOON',
                  style: TextStyle(
                    color: AppColors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title & Description
        const Text(
          'Driver Mobile App',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'The dedicated companion app for fleet drivers is under active development. Drivers will soon receive dispatches, report live status, and upload e-POD receipts on mobile.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),

        // Feature Highlights
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            children: [
              _buildDriverFeatureRow(
                Icons.local_shipping_outlined,
                'Live Trip Dispatch & Queue',
              ),
              const SizedBox(height: 8),
              _buildDriverFeatureRow(
                Icons.navigation_outlined,
                'Turn-by-Turn CFS & Port Navigation',
              ),
              const SizedBox(height: 8),
              _buildDriverFeatureRow(
                Icons.camera_alt_outlined,
                'Digital e-POD & Seal Photo Upload',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverFeatureRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accentLight),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
