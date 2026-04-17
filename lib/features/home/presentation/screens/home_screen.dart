import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/service_card.dart';
import '../../../../shared/widgets/health_tip_card.dart';
import '../../../../shared/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Accueil',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today_outlined),
      activeIcon: Icon(Icons.calendar_today),
      label: 'Rendez-vous',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      activeIcon: Icon(Icons.chat_bubble),
      label: 'Chatbot',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.map_outlined),
      activeIcon: Icon(Icons.map),
      label: 'Carte',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  final List<Widget> _screens = [
    const _HomeTab(),
    const SizedBox(), // Will be replaced with AppointmentsScreen
    const SizedBox(), // Will be replaced with ChatbotScreen
    const SizedBox(), // Will be replaced with MapScreen
    const SizedBox(), // Will be replaced with ProfileScreen
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to respective screens
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        context.push(AppRouter.appointments);
        break;
      case 2:
        context.push(AppRouter.chatbot);
        break;
      case 3:
        context.push(AppRouter.map);
        break;
      case 4:
        context.push(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.white,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.darkGray,
          items: _bottomNavItems,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec profil
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Photo de profil
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primaryBlue,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Message de bienvenue
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour ${user?['name'] ?? 'Test User'} !',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Comment vous sentez-vous aujourd\'hui ?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icône notifications
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppTheme.darkGray,
                            size: 20,
                          ),
                        ),
                        // Badge pour notifications non lues
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.softRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Search Bar
            FadeInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: CustomSearchBar(
                hintText: 'Rechercher un besoin santé...',
                onTap: () {
                  // TODO: Implement search functionality
                },
              ),
            ),

            const SizedBox(height: 32),

            // Services Cards
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 600),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  ServiceCard(
                    icon: Icons.calendar_month,
                    title: 'Prendre rendez-vous',
                    color: AppTheme.primaryBlue,
                    onTap: () => context.push(AppRouter.appointments),
                  ),
                  ServiceCard(
                    icon: Icons.smart_toy,
                    title: 'Chatbot santé',
                    color: AppTheme.secondaryGreen,
                    onTap: () => context.push(AppRouter.chatbot),
                  ),
                  ServiceCard(
                    icon: Icons.local_pharmacy,
                    title: 'Pharmacies proches',
                    color: Colors.orange,
                    onTap: () => context.push(AppRouter.map),
                  ),
                  ServiceCard(
                    icon: Icons.lightbulb,
                    title: 'Conseils rapides',
                    color: Colors.purple,
                    onTap: () => context.push(AppRouter.chatbot),
                  ),
                  ServiceCard(
                    icon: Icons.emergency,
                    title: 'Urgences',
                    color: AppTheme.softRed,
                    onTap: () => context.push(AppRouter.map),
                  ),
                  ServiceCard(
                    icon: Icons.folder_shared,
                    title: 'Dossier médical',
                    color: Colors.teal,
                    onTap: () => context.push(AppRouter.profile),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Services Populaires
            FadeInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services populaires',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPopularService(
                          context,
                          'Consultation générale',
                          Icons.medical_services,
                          AppTheme.primaryBlue,
                        ),
                        const SizedBox(width: 12),
                        _buildPopularService(
                          context,
                          'Pédiatrie',
                          Icons.child_care,
                          Colors.pink,
                        ),
                        const SizedBox(width: 12),
                        _buildPopularService(
                          context,
                          'Gynécologie',
                          Icons.female,
                          Colors.purple,
                        ),
                        const SizedBox(width: 12),
                        _buildPopularService(
                          context,
                          'Dentisterie',
                          Icons.healing,
                          Colors.cyan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Conseils du jour
            FadeInRight(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conseils du jour',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  HealthTipCard(
                    title: 'Hydratez-vous régulièrement',
                    description: 'Buvez au moins 8 verres d\'eau par jour pour maintenir votre corps en bonne santé.',
                    icon: Icons.water_drop,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(height: 12),
                  HealthTipCard(
                    title: 'Faites de l\'exercice',
                    description: '30 minutes d\'activité physique par jour peuvent réduire les risques de maladies.',
                    icon: Icons.directions_run,
                    color: AppTheme.secondaryGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularService(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
