import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/app_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/profile_menu_item.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController(text: 'Test User');
  final TextEditingController _emailController = TextEditingController(text: 'test@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+221 77 123 45 67');
  final TextEditingController _addressController = TextEditingController(text: 'Dakar, Sénégal');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _phoneController.text = user['phone'] ?? '';
      _emailController.text = user['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final authProvider = context.read<AuthProvider>();
    
    await authProvider.updateProfile({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
    });

    if (mounted && authProvider.errorMessage == null) {
      setState(() {
        _isEditing = false;
      });
      _showSuccessMessage('Profil mis à jour avec succès');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.secondaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          CustomButton(
            text: 'Se déconnecter',
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              if (mounted) {
                context.pushReplacement(AppRouter.login);
              }
            },
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier profil' : 'Profil'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryBlue,
                            AppTheme.primaryBlue.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Picture
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppTheme.white,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryGreen,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            authProvider.user?['name'] ?? 'Utilisateur',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authProvider.user?['email'] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Profile Form
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations personnelles',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Nom complet',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: _isEditing ? AppTheme.lightGray : AppTheme.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Téléphone',
                            prefixIcon: const Icon(Icons.phone),
                            filled: true,
                            fillColor: _isEditing ? AppTheme.lightGray : AppTheme.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            filled: true,
                            fillColor: _isEditing ? AppTheme.lightGray : AppTheme.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _isEditing ? AppTheme.mediumGray : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        
                        if (_isEditing) ...[
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Annuler',
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                    _loadUserData();
                                  },
                                  type: ButtonType.outlined,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  text: 'Sauvegarder',
                                  onPressed: _updateProfile,
                                  type: ButtonType.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Menu Items
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paramètres',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        ProfileMenuItem(
                          icon: Icons.history,
                          title: 'Historique des rendez-vous',
                          subtitle: 'Voir vos consultations passées',
                          onTap: () {
                            // TODO: Navigate to appointment history
                          },
                        ),
                        
                        ProfileMenuItem(
                          icon: Icons.folder_shared,
                          title: 'Dossier médical',
                          subtitle: 'Accéder à vos informations médicales',
                          onTap: () {
                            // TODO: Navigate to medical records
                          },
                        ),
                        
                        ProfileMenuItem(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          subtitle: 'Gérer les préférences de notification',
                          onTap: () {
                            // TODO: Navigate to notification settings
                          },
                        ),
                        
                        Consumer<AppProvider>(
                          builder: (context, appProvider, child) {
                            return ProfileMenuItem(
                              icon: appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              title: 'Mode sombre',
                              subtitle: appProvider.isDarkMode ? 'Désactiver le mode sombre' : 'Activer le mode sombre',
                              onTap: () {
                                appProvider.toggleDarkMode();
                              },
                              trailing: Switch(
                                value: appProvider.isDarkMode,
                                onChanged: (_) => appProvider.toggleDarkMode(),
                              ),
                            );
                          },
                        ),
                        
                        ProfileMenuItem(
                          icon: Icons.privacy_tip,
                          title: 'Confidentialité',
                          subtitle: 'Gérer vos données personnelles',
                          onTap: () {
                            // TODO: Navigate to privacy settings
                          },
                        ),
                        
                        ProfileMenuItem(
                          icon: Icons.help,
                          title: 'Aide et support',
                          subtitle: 'Obtenir de l\'aide',
                          onTap: () {
                            // TODO: Navigate to help
                          },
                        ),
                        
                        ProfileMenuItem(
                          icon: Icons.info,
                          title: 'À propos',
                          subtitle: 'Version 1.0.0',
                          onTap: () {
                            // TODO: Show about dialog
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Logout Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.softRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.softRed.withOpacity(0.3),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: AppTheme.softRed,
                            ),
                            title: Text(
                              'Se déconnecter',
                              style: TextStyle(
                                color: AppTheme.softRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: _showLogoutDialog,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
