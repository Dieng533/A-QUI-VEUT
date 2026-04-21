import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? followUpQuestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.followUpQuestions,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: AppTheme.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppTheme.primaryBlue
                        : AppTheme.lightGray,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: message.isUser
                              ? AppTheme.white
                              : AppTheme.black,
                        ),
                      ),
                      if (message.followUpQuestions != null &&
                          message.followUpQuestions!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ...message.followUpQuestions!.map((question) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: message.isUser
                                    ? AppTheme.white.withOpacity(0.2)
                                    : AppTheme.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: message.isUser
                                      ? AppTheme.white.withOpacity(0.3)
                                      : AppTheme.mediumGray.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: message.isUser
                                        ? AppTheme.white
                                        : AppTheme.secondaryGreen,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      question,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: message.isUser
                                            ? AppTheme.white
                                            : AppTheme.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.white,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
              left: message.isUser ? 0 : 40,
              right: message.isUser ? 40 : 0,
            ),
            child: Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

