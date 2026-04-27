import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

class HomeAiChatScreen extends StatefulWidget {
  const HomeAiChatScreen({super.key});

  @override
  State<HomeAiChatScreen> createState() => _HomeAiChatScreenState();
}

class _HomeAiChatScreenState extends State<HomeAiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<_ChatMessage> _messages = <_ChatMessage>[];

  static const List<String> _suggestionPrompts = <String>[
    'What is Ramadan?',
    'Prayer times',
    'Quran reading plan',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chatBackground = colorScheme.surface;
    final composerBackground = colorScheme.surface;
    final inputBackground = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.85);

    return Scaffold(
      backgroundColor: chatBackground,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: l10n.homeAiChatTitle,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? _HomeAiChatEmptyState(
                        colorScheme: colorScheme,
                        onSuggestion: _applySuggestion,
                        suggestions: _suggestionPrompts,
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message =
                              _messages[_messages.length - 1 - index];
                          return _ChatBubble(message: message);
                        },
                      ),
              ),
              Material(
                color: composerBackground,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _inputController,
                            minLines: 1,
                            maxLines: 5,
                            textInputAction: TextInputAction.send,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: l10n.homeAiAskQuestionHint,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              hintStyle: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _canSend ? _sendMessage : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.homeAiSend,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applySuggestion(String text) {
    _inputController.text = text;
    setState(() {});
  }

  bool get _canSend => _inputController.text.trim().isNotEmpty && !_isLoading;

  Future<void> _sendMessage() async {
    final l10n = AppLocalizations.of(context)!;
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

    if (!mounted) return;

    try {
      final reply = await _callOpenAi();
      if (!mounted) return;
      _replaceLoadingMessage(reply);
    } catch (error) {
      if (!mounted) return;
      _replaceLoadingMessage(
        '${l10n.homeAiErrorPrefix} ${error.toString()}',
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
  }
}

class _HomeAiChatEmptyState extends StatelessWidget {
  const _HomeAiChatEmptyState({
    required this.colorScheme,
    required this.onSuggestion,
    required this.suggestions,
  });

  final ColorScheme colorScheme;
  final ValueChanged<String> onSuggestion;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final muted = colorScheme.surfaceContainerHighest.withValues(alpha: 0.75);
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 28,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.homeAiEmptyTitle,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeAiEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: suggestions
                        .map(
                          (q) => Material(
                            color: muted,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () => onSuggestion(q),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  q,
                                  style: textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
      appBar: CustomAppBar(title: title),
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

    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.85;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : assistantBubbleColor,
          borderRadius: BorderRadius.circular(16),
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
