// AuthRepository is expected to exist in your project.
// If your repo uses a different path/name, update the import accordingly.

import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../service/local_storage_service.dart';
import '../widgets/auth_base_widgets.dart';
import '../widgets/common_snackbar.dart';

// Firebase auth will be wired in once firebase_auth is added to pubspec.yaml.

// (Left here as the next integration step.)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // These will authenticate only if a user with this email/password exists.
  static const String adminEmail = 'admin@example.com';
  static const String adminPassword = 'admin123';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // If user already loggedin, skip directly.
    LocalStorageService.isLoggedIn().then((loggedIn) {
      if (!mounted) return;
      if (loggedIn) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handlePrimaryButtonClick({required bool isLogin}) async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (email.isEmpty || password.isEmpty) {
        CommonSnackBar.showError(
          context,
          'Email and password cannot be empty.',
        );
        return;
      }

      // Demo credentials gate (temporary until real auth is wired).
      final isAdminLogin = email == adminEmail && password == adminPassword;

      if (!isAdminLogin) {
        CommonSnackBar.showError(
          context,
          isLogin
              ? 'Invalid email or password.'
              : 'Account creation is disabled for demo. Use the admin credentials.',
        );
        return;
      }

      // Persist "logged in" flag in local storage.
      await LocalStorageService.setLoggedIn(true);

      if (!mounted) return;
      CommonSnackBar.showSuccess(
        context,
        isLogin ? 'Logged in successfully.' : 'Account created successfully.',
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } catch (e) {
      if (!mounted) return;
      CommonSnackBar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF2FF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    AuthCard(
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Login'),
                              Tab(text: 'Sign up'),
                            ],
                            indicator: BoxDecoration(
                              color: const Color(
                                0xFF3B5BDB,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelColor: const Color(0xFF1A237E),
                            unselectedLabelColor: Colors.black54,
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              final isLogin = _tabController.index == 0;
                              return Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    AuthTextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: const [
                                        AutofillHints.email,
                                      ],
                                      labelText: 'Email',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                      ),
                                      validator: (v) {
                                        final value = v?.trim() ?? '';
                                        if (value.isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!value.contains('@') ||
                                            !value.contains('.')) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    AuthTextField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      labelText: 'Password',
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? 'Show password'
                                            : 'Hide password',
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                      ),
                                      validator: (v) {
                                        final value = v ?? '';
                                        if (value.isEmpty) {
                                          return 'Password is required';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    if (!isLogin) ...[
                                      const SizedBox(height: 12),
                                      AuthTextField(
                                        controller: _confirmPasswordController,
                                        obscureText: _obscureConfirmPassword,
                                        autofillHints: const [
                                          AutofillHints.newPassword,
                                        ],
                                        labelText: 'Confirm password',
                                        prefixIcon: const Icon(
                                          Icons.lock_reset_outlined,
                                        ),
                                        suffixIcon: IconButton(
                                          tooltip: _obscureConfirmPassword
                                              ? 'Show password'
                                              : 'Hide password',
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscureConfirmPassword =
                                                !_obscureConfirmPassword,
                                          ),
                                        ),
                                        validator: (v) {
                                          final value = v ?? '';
                                          if (value.isEmpty) {
                                            return 'Confirm password is required';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                    const SizedBox(height: 18),
                                    AuthPrimaryButton(
                                      text: isLogin
                                          ? 'Login'
                                          : 'Create account',
                                      onPressed: () =>
                                          _handlePrimaryButtonClick(
                                            isLogin: isLogin,
                                          ),
                                    ),
                                    if (isLogin) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: AuthSecondaryTextButton(
                                          text: 'Forgot password?',
                                          onPressed: () {
                                            // Placeholder UX.
                                            CommonSnackBar.showInfo(
                                              context,
                                              'Password reset not implemented yet.',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF3B5BDB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Login or create a new account',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
