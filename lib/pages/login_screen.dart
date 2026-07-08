import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/auth_repository.dart';
import '../widgets/auth_base_widgets.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
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
                                      onPressed: () async {
                                        final ok =
                                            _formKey.currentState?.validate() ??
                                            false;
                                        if (!ok) return;

                                        final email = _emailController.text
                                            .trim();
                                        final password =
                                            _passwordController.text;

                                        try {
                                          if (isLogin) {
                                            final ok =
                                                await AuthRepository.login(
                                                  email: email,
                                                  password: password,
                                                );
                                            if (!ok) {
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invalid email or password',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                          } else {
                                            await AuthRepository.signUp(
                                              email: email,
                                              password: password,
                                            );
                                          }

                                          if (!mounted) return;
                                          Navigator.of(
                                            context,
                                          ).pushNamedAndRemoveUntil(
                                            AppRoutes.dashboard,
                                            (route) => false,
                                          );
                                        } on StateError catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(e.message)),
                                          );
                                        } catch (_) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Authentication failed',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    if (isLogin) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: AuthSecondaryTextButton(
                                          text: 'Forgot password?',
                                          onPressed: () {
                                            // Placeholder UX.
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Password reset not implemented yet.',
                                                ),
                                              ),
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

                    const SizedBox(height: 12),
                    _buildFooterHint(context),
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

  Widget _buildFooterHint(BuildContext context) {
    return Text(
      'Note: This screen is UI-only right now. Connect your auth/database later.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black.withValues(alpha: 0.55),
        fontSize: 12,
      ),
    );
  }
}
