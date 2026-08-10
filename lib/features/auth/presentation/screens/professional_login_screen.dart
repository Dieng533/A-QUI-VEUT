import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class ProfessionalLoginScreen extends StatefulWidget {
  const ProfessionalLoginScreen({super.key});

  @override
  State<ProfessionalLoginScreen> createState() => _ProfessionalLoginScreenState();
}

class _ProfessionalLoginScreenState extends State<ProfessionalLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (authProvider.isAuthenticated) {
        final user = authProvider.user;
        if (user?['role'] == 'professional') {
          if (mounted) {
            context.pushReplacement(AppRouter.professionalDashboard);
          }
        } else {
          _showErrorMessage('Ce compte n\'est pas un compte professionnel');
        }
      } else {
        _showErrorMessage(authProvider.errorMessage ?? 'Erreur de connexion');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.softRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Header
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.arrow_back),
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.lightGray,
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Logo
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/logoaquiveut.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Connexion Professionnel',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Accédez à votre espace professionnel',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.lightBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppTheme.primaryBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Un compte professionnel doit être créé par l\'administrateur avant de pouvoir se connecter',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Formulaire de connexion
                      FadeInLeft(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 200),
                        child: CustomTextField(
                          controller: _emailController,
                          label: 'Email professionnel',
                          hintText: 'professionnel@exemple.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email professionnel';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      FadeInLeft(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 300),
                        child: CustomTextField(
                          controller: _passwordController,
                          label: 'Mot de passe',
                          hintText: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: AppTheme.darkGray,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Bouton de connexion
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 400),
                        child: CustomButton(
                          text: 'Se connecter',
                          onPressed: _handleLogin,
                          isLoading: authProvider.isLoading,
                          isFullWidth: true,
                          height: 56,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Lien vers connexion admin
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Administrateur ?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGray,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushReplacement(AppRouter.adminLogin);
                              },
                              child: Text(
                                'Connexion Admin',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
