import 'dart:async';

import 'package:flutter/widgets.dart';

import '../data/library_content_language.dart';

/// Reloads library content when the app language changes.
mixin LibraryLanguageReload<T extends StatefulWidget> on State<T> {
  String? _libraryLanguage;
  int _libraryLoadGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = libraryContentLanguageCode(
      Localizations.localeOf(context).languageCode,
    );
    if (_libraryLanguage == code) return;
    _libraryLanguage = code;
    final generation = ++_libraryLoadGeneration;
    unawaited(onLibraryLanguage(code, generation));
  }

  bool isCurrentLibraryLoad(int generation) =>
      mounted && generation == _libraryLoadGeneration;

  Future<void> onLibraryLanguage(String languageCode, int generation);
}
