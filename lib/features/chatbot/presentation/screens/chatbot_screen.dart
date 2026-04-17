import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chat_bubble.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Bonjour! Je suis votre assistant santé. Comment puis-je vous aider aujourd\'hui?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  final List<String> _quickSuggestions = [
    'Maux de tête',
    'Fièvre',
    'Petite blessure',
    'Hémorragie',
    'Contraception',
    'Grossesse',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      _generateBotResponse(message);
    });
  }

  void _generateBotResponse(String userMessage) {
    String response;
    List<String> followUpQuestions = [];

    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('mal de tête') || lowerMessage.contains('maux de tête')) {
      response = 'Je comprends que vous avez des maux de tête. Voici quelques conseils:';
      followUpQuestions = [
        'Reposez-vous dans un endroit calme et sombre',
        'Hydratez-vous bien',
        'Évitez les écrans lumineux',
      ];
    } else if (lowerMessage.contains('fièvre')) {
      response = 'Pour la fièvre, voici ce que je vous recommande:';
      followUpQuestions = [
        'Prenez du paracétamol si nécessaire',
        'Buvez beaucoup de liquides',
        'Reposez-vous suffisamment',
      ];
    } else if (lowerMessage.contains('blessure')) {
      response = 'Pour une petite blessure:';
      followUpQuestions = [
        'Nettoyez la plaie avec de l\'eau et du savon',
        'Appliquez un désinfectant',
        'Protégez avec un pansement',
      ];
    } else if (lowerMessage.contains('hémorragie')) {
      response = '⚠️ URGENCE: En cas d\'hémorragie:';
      followUpQuestions = [
        'Comprimez la plaie fermement',
        'Allongez la personne et surélevez le membre blessé',
        'Appelez immédiatement les urgences (15)',
      ];
    } else if (lowerMessage.contains('contraception')) {
      response = 'Concernant la contraception, plusieurs options sont disponibles:';
      followUpQuestions = [
        'Préservatifs masculins/féminins',
        'Pilules contraceptives',
        'DIU (stérilet)',
        'Implant contraceptif',
      ];
    } else if (lowerMessage.contains('grossesse')) {
      response = 'Pour la grossesse, voici les informations importantes:';
      followUpQuestions = [
        'Faites un test de grossesse en cas de doute',
        'Consultez rapidement un professionnel de santé',
        'Suivez une alimentation équilibrée',
        'Évitez l\'alcool et le tabac',
      ];
    } else {
      response = 'Je suis là pour vous aider. Pour des conseils précis, veuillez consulter un professionnel de santé.';
    }

    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        followUpQuestions: followUpQuestions,
      ));
    });

    _scrollToBottom();
  }

  void _handleQuickSuggestion(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Assistant Santé'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
      ),
      body: Column(
        children: [
          // Quick Suggestions
          if (_messages.length == 1)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.lightBlue.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions rapides:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickSuggestions.map((suggestion) {
                      return ActionChip(
                        label: Text(suggestion),
                        onPressed: () => _handleQuickSuggestion(suggestion),
                        backgroundColor: AppTheme.white,
                        side: BorderSide(color: AppTheme.primaryBlue),
                        labelStyle: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return FadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: ChatBubble(
                    message: message,
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    label: 'Message',
                    hintText: 'Tapez votre message...',
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.white,
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

