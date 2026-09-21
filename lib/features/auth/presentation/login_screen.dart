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

enum LoginRole {
  superAdmin,
  coordinator,
  driver,
}

enum SuperAdminOption {
  operations,
  attendance,
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  LoginRole _selectedRole = LoginRole.superAdmin;
  SuperAdminOption _adminOption = SuperAdminOption.operations;

  // Form controllers for Operations Login
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@freightops.com');
  final _passwordCtrl = TextEditingController(text: 'admin123');
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

  void _switchAdminOption(SuperAdminOption option) {
    setState(() {
      _adminOption = option;
      _pinError = null;
      _pinController.clear();
    });
  }

  Future<void> _handleOperationsLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );

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

    final isAttendance = _selectedRole == LoginRole.superAdmin &&
        _adminOption == SuperAdminOption.attendance;

    final success = await ref.read(authProvider.notifier).loginWithPin(
          pin: pin,
          role: roleName,
        );

    if (!mounted) return;

    if (success) {
      if (isAttendance) {
        await ref.read(authServiceProvider).saveAttendanceSession(role: roleName);
        if (mounted) {
          context.go('/attendance');
        }
      } else {
        context.go('/dashboard');
      }
    } else {
      final authState = ref.read(authProvider);
      setState(() {
        _pinError = authState.errorMessage ?? 'Invalid PIN. Enter 1170 for demo.';
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
                    child: const Icon(Icons.local_shipping, color: Colors.white, size: 34),
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
                      border: Border.all(color: AppColors.red.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.red, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
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
                    subtitle: 'Enter your 4-digit Coordinator PIN to access dispatch and fleet queue.',
                    icon: Icons.assignment_ind_outlined,
                    isLoading: authState.isLoading,
                  ),
                ] else ...[
                  _buildPinLoginSection(
                    title: 'Driver Portal Access',
                    subtitle: 'Enter your 4-digit Driver PIN to view assigned trips and container deliveries.',
                    icon: Icons.badge_outlined,
                    isLoading: authState.isLoading,
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Two Sub-Options for Super Admin: Transport Operations vs Attendance Section
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSubOptionButton(
                  option: SuperAdminOption.operations,
                  title: 'Transport Operations',
                  icon: Icons.local_shipping_outlined,
                  isSelected: _adminOption == SuperAdminOption.operations,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildSubOptionButton(
                  option: SuperAdminOption.attendance,
                  title: 'Attendance Section',
                  icon: Icons.fingerprint,
                  isSelected: _adminOption == SuperAdminOption.attendance,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Sub Option 1: Existing Operations Login (Email & Password)
        if (_adminOption == SuperAdminOption.operations) ...[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Email Address',
                  controller: _emailCtrl,
                  hint: 'admin@freightops.com',
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
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Password is required';
                    if (val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColors.accentLight, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Sign In to Operations',
                  icon: Icons.login,
                  isLoading: isLoading,
                  onPressed: _handleOperationsLogin,
                ),
              ],
            ),
          ),
        ] else ...[
          // Sub Option 2: Attendance Section (4-digit PIN)
          _buildPinLoginSection(
            title: 'Attendance Section Access',
            subtitle: 'Enter 4-digit Security PIN to access the Staff Attendance system.',
            icon: Icons.fingerprint,
            isLoading: isLoading,
          ),
        ],
      ],
    );
  }

  Widget _buildSubOptionButton({
    required SuperAdminOption option,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _switchAdminOption(option),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF334155) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.accentLight : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        const SizedBox(height: 20),

        // Demo PIN Helper Badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.key, color: AppColors.accentLight, size: 14),
                SizedBox(width: 6),
                Text(
                  'Demo PIN: 1170',
                  style: TextStyle(
                    color: AppColors.accentLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

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
              style: const TextStyle(color: AppColors.red, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],

        const SizedBox(height: 8),

        // Enter PIN Button
        AppButton(
          text: _selectedRole == LoginRole.superAdmin && _adminOption == SuperAdminOption.attendance
              ? 'Access Attendance System'
              : 'Sign In with PIN',
          icon: Icons.lock_open,
          isLoading: isLoading,
          onPressed: () => _handlePinSubmit(_pinController.text),
        ),
      ],
    );
  }
}
