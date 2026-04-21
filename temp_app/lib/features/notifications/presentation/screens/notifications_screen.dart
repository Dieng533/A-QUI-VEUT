import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Rappel de rendez-vous',
      message: 'Vous avez un rendez-vous avec Dr. Marie Sarr demain à 14h00',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.appointment,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Conseil santé du jour',
      message: 'N\'oubliez pas de boire au moins 8 verres d\'eau par jour',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.healthTip,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Rendez-vous confirmé',
      message: 'Votre rendez-vous du 15 Mars a été confirmé',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.appointment,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Nouveau service disponible',
      message: 'Consultez nos nouveaux services de téléconsultation',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Alerte santé',
      message: 'Pensez à faire votre bilan annuel de santé',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.healthAlert,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                label: Text(unreadCount.toString()),
                backgroundColor: AppTheme.primaryBlue,
                child: IconButton(
                  onPressed: _markAllAsRead,
                  icon: const Icon(Icons.done_all),
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return FadeIn(
                  duration: const Duration(milliseconds: 300),
                  delay: Duration(milliseconds: index * 100),
                  child: NotificationCard(
                    notification: notification,
                    onTap: () => _markAsRead(notification.id),
                    onDelete: () => _deleteNotification(notification.id),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: AppTheme.darkGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous recevrez vos notifications ici',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notificationId);
    });
  }
}

