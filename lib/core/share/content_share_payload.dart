class ContentShareField {
  const ContentShareField({required this.label, required this.value});

  final String label;
  final String value;
}

/// Structured copy for the share message — not a dump of the full card.
class ContentSharePayload {
  const ContentSharePayload({
    required this.title,
    this.paragraphs = const [],
    this.fields = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<ContentShareField> fields;

  String buildMessage({
    required String intro,
    required String exploreLabel,
    required String storeLinks,
  }) {
    return '$intro\n\n$exploreLabel\n\n$storeLinks';
  }
}
