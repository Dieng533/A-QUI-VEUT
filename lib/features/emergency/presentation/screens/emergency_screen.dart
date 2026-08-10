import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Urgences'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.alertRed.withOpacity(0.1),
                      AppTheme.alertRed.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.alertRed.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.alertRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emergency,
                        color: AppTheme.alertRed,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Numéros d\'Urgence',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.alertRed,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Contactez rapidement les services d\'urgence',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Numbers
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Text(
                'Services d\'Urgence',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: _EmergencyCard(
                title: 'SAMU',
                subtitle: 'Service d\'Aide Médicale Urgente',
                number: '15',
                icon: Icons.local_hospital,
                color: AppTheme.alertRed,
                isPrimary: true,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1100),
              child: _EmergencyCard(
                title: 'Pompiers',
                subtitle: 'Secours et incendie',
                number: '18',
                icon: Icons.fire_truck,
                color: AppTheme.alertRed,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: _EmergencyCard(
                title: 'Police',
                subtitle: 'Sécurité et ordre public',
                number: '17',
                icon: Icons.local_police,
                color: AppTheme.alertRed,
              ),
            ),

            const SizedBox(height: 24),

            // Local Emergency Services
            FadeInUp(
              duration: const Duration(milliseconds: 1300),
              child: Text(
                'Services Locaux - Saint-Louis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: _EmergencyCard(
                title: 'Hôpital Régional',
                subtitle: 'Urgences médicales 24h/24',
                number: '+221 33 961 23 45',
                icon: Icons.local_hospital,
                color: AppTheme.primaryBlue,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: _EmergencyCard(
                title: 'Protection Civile',
                subtitle: 'Secours d\'urgence',
                number: '+221 33 961 34 56',
                icon: Icons.health_and_safety,
                color: AppTheme.primaryBlue,
              ),
            ),

            const SizedBox(height: 24),

            // Tips Section
            FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conseils Importants',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(
                      icon: Icons.check_circle,
                      text: 'Gardez votre calme et parlez clairement',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.check_circle,
                      text: 'Précisez votre localisation exacte',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.check_circle,
                      text: 'Décrivez la nature de l\'urgence',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.check_circle,
                      text: 'Suivez les conseils du professionnel',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final IconData icon;
  final Color color;
  final bool isPrimary;

  const _EmergencyCard({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.icon,
    required this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _callEmergency(number),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGray,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.call,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _callEmergency(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.secondaryGreen,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.darkGray,
            ),
          ),
        ),
      ],
    );
  }
}
