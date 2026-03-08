import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class HomeAiChatScreen extends StatelessWidget {
  const HomeAiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return HomeSimpleInfoScreen(
      title: l10n.featureAiAssistant,
      subtitle: l10n.homeAiChatDescription,
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
