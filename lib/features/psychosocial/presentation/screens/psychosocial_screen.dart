import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class PsychosocialScreen extends StatelessWidget {
  const PsychosocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Soutien Psychosocial'),
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
                      AppTheme.primaryBlue.withOpacity(0.1),
                      AppTheme.primaryBlue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soutien Psychologique',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Écoute et accompagnement professionnel',
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

            // Support Services
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Text(
                'Services de Soutien',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: _SupportCard(
                title: 'Ligne d\'Écoute',
                subtitle: 'Disponible 24h/24 et 7j/7',
                number: '141',
                icon: Icons.phone_in_talk,
                color: AppTheme.primaryBlue,
                isPrimary: true,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1100),
              child: _SupportCard(
                title: 'SOS Suicide',
                subtitle: 'Aide immédiate en cas de crise',
                number: '3314',
                icon: Icons.emergency,
                color: AppTheme.alertRed,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: _SupportCard(
                title: 'Enfance en Danger',
                subtitle: 'Protection des mineurs',
                number: '119',
                icon: Icons.child_care,
                color: AppTheme.secondaryGreen,
              ),
            ),

            const SizedBox(height: 24),

            // Local Services
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
              child: _SupportCard(
                title: 'Centre de Santé Mentale',
                subtitle: 'Consultations psychologiques',
                number: '+221 33 961 45 67',
                icon: Icons.psychology,
                color: AppTheme.primaryBlue,
              ),
            ),

            const SizedBox(height: 12),

            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: _SupportCard(
                title: 'Association d\'Aide',
                subtitle: 'Accompagnement social',
                number: '+221 77 123 45 67',
                icon: Icons.volunteer_activism,
                color: AppTheme.secondaryGreen,
              ),
            ),

            const SizedBox(height: 24),

            // Resources Section
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
                          Icons.menu_book,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ressources Utiles',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ResourceItem(
                      icon: Icons.web,
                      title: 'Site de prévention suicide',
                      description: 'www.prevention-suicide.fr',
                      url: 'https://www.prevention-suicide.fr',
                    ),
                    const SizedBox(height: 8),
                    _ResourceItem(
                      icon: Icons.web,
                      title: 'Fil Santé Jeunes',
                      description: 'Information et orientation',
                      url: 'https://www.filsantejeunes.com',
                    ),
                    const SizedBox(height: 8),
                    _ResourceItem(
                      icon: Icons.web,
                      title: 'Santé mentale Sénégal',
                      description: 'Ressources locales',
                      url: 'https://www.sante.gouv.sn',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tips Section
            FadeInUp(
              duration: const Duration(milliseconds: 1700),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.secondaryGreen.withOpacity(0.1),
                      AppTheme.secondaryGreen.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.secondaryGreen.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: AppTheme.secondaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conseils pour le Bien-être',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TipItem(
                      icon: Icons.self_improvement,
                      text: 'Prenez soin de votre corps et de votre esprit',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.people,
                      text: 'Maintenez des relations sociales positives',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.work,
                      text: 'Trouvez un équilibre vie pro/vie perso',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      icon: Icons.favorite,
                      text: 'Pratiquez des activités que vous aimez',
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

class _SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final IconData icon;
  final Color color;
  final bool isPrimary;

  const _SupportCard({
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
        onTap: () => _callSupport(number),
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

  void _callSupport(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

class _ResourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _ResourceItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openWebsite(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.launch,
              color: AppTheme.primaryBlue,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _openWebsite(String url) async {
    final Uri websiteUri = Uri.parse(url);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
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
