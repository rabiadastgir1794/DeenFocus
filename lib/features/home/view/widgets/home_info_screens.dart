import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../core/widgets/widgets.dart';

class HomeAiChatScreen extends StatefulWidget {
  const HomeAiChatScreen({super.key});

  @override
  State<HomeAiChatScreen> createState() => _HomeAiChatScreenState();
}

class _HomeAiChatScreenState extends State<HomeAiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = <_ChatMessage>[
    const _ChatMessage(
      role: _ChatRole.assistant,
      content:
          "As-salamu alaykum! I'm here to help with prayer, Quran, and Islamic guidance. What would you like to ask?",
    ),
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chatBackground = colorScheme.surface;
    final composerBackground = colorScheme.surface;
    final inputBackground = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
        : const Color(0xFFF6F2E9);
    final inputBorderColor =
        isDark ? colorScheme.outlineVariant : const Color(0xFFE6DBC5);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 58,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: AppTopBackButton(
            onTap: () => Navigator.of(context).pop(),
            semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
          ),
        ),
        title: const Text('Islamic Chat'),
      ),
      backgroundColor: chatBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _ChatBubble(message: message);
                },
              ),
            ),
            Material(
              color: composerBackground,
              elevation: 8,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: inputBorderColor),
                          ),
                          child: TextField(
                            controller: _inputController,
                            enabled: !_isLoading,
                            minLines: 1,
                            maxLines: 5,
                            textInputAction: TextInputAction.send,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'Ask a question',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              hintStyle: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkResponse(
                        onTap: _canSend ? _sendMessage : null,
                        radius: 24,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _canSend
                                ? colorScheme.primary
                                : colorScheme.outlineVariant.withValues(
                                    alpha: 0.35,
                                  ),
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            size: 20,
                            color: _canSend
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canSend => _inputController.text.trim().isNotEmpty && !_isLoading;

  Future<void> _sendMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(role: _ChatRole.user, content: input));
      _inputController.clear();
      _isLoading = true;
      _messages.add(
        const _ChatMessage(
          role: _ChatRole.assistant,
          content: 'LOADING_PLACEHOLDER',
        ),
      );
    });
    _scrollToBottom();

    if (!mounted) return;

    try {
      final reply = await _callOpenAi();
      if (!mounted) return;
      _replaceLoadingMessage(reply);
    } catch (error) {
      if (!mounted) return;
      _replaceLoadingMessage(
        'Sorry, I ran into an issue while connecting to Islamic Chat. ${error.toString()}',
      );
    }
  }

  Future<String> _callOpenAi() async {
    if (!AppConfig.hasOpenAiApiKey) {
      throw Exception('Missing OPENAI_API_KEY.');
    }

    final uri = Uri.parse('${AppConfig.openAiBaseUrl}/chat/completions');
    final requestMessages = <Map<String, String>>[
      const <String, String>{
        'role': 'developer',
        'content':
            'You are a knowledgeable and respectful Islamic scholar assistant. Help users learn about Islamic traditions, holidays, prayers, Quran study, and spiritual practices. Be warm, concise, educational, and culturally sensitive. If the user asks something outside Islamic guidance, answer helpfully without pretending religious certainty.',
      },
      for (final message in _messages)
        if (message.content != 'LOADING_PLACEHOLDER')
          <String, String>{
            'role': message.role.name,
            'content': message.content,
          },
    ];

    final response = await http
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
          },
          body: jsonEncode(<String, dynamic>{
            'model': AppConfig.openAiChatModel,
            'messages': requestMessages,
            'temperature': 0.7,
            'max_completion_tokens': 800,
          }),
        )
        .timeout(const Duration(seconds: 40));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>? ?? const <dynamic>[];
    if (choices.isEmpty) {
      throw Exception('No response returned from the API.');
    }

    final firstChoice = choices.first as Map<String, dynamic>;
    final message = firstChoice['message'] as Map<String, dynamic>? ?? const {};
    final content = message['content'];

    if (content is String && content.trim().isNotEmpty) {
      return content.trim();
    }

    if (content is List) {
      final buffer = StringBuffer();
      for (final item in content.whereType<Map<String, dynamic>>()) {
        if (item['type'] == 'text' && item['text'] is String) {
          buffer.write(item['text'] as String);
        }
      }
      final text = buffer.toString().trim();
      if (text.isNotEmpty) return text;
    }

    throw Exception('Empty response content.');
  }

  void _replaceLoadingMessage(String reply) {
    final loadingIndex = _messages.indexWhere(
      (message) => message.content == 'LOADING_PLACEHOLDER',
    );

    setState(() {
      _isLoading = false;
      if (loadingIndex >= 0) {
        _messages[loadingIndex] = _ChatMessage(
          role: _ChatRole.assistant,
          content: reply,
        );
      } else {
        _messages.add(_ChatMessage(role: _ChatRole.assistant, content: reply));
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }
}

class HomeSimpleInfoScreen extends StatelessWidget {
  const HomeSimpleInfoScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(subtitle, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

enum _ChatRole { user, assistant }

class _ChatMessage {
  const _ChatMessage({required this.role, required this.content});

  final _ChatRole role;
  final String content;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == _ChatRole.user;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = message.content == 'LOADING_PLACEHOLDER';
    final assistantBubbleColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.75)
        : const Color(0xFFF6F2E9);
    final assistantTextColor = colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : assistantBubbleColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: isLoading
            ? SizedBox(
                width: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    3,
                    (_) => Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            : Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isUser ? colorScheme.onPrimary : assistantTextColor,
                  height: 1.35,
                ),
              ),
      ),
    );
  }
}
