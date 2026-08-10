class LibrarySectionProgress {
  const LibrarySectionProgress({
    this.lastIndex = 0,
    this.completed = false,
    this.bookmarks = const <int>{},
  });

  final int lastIndex;
  final bool completed;
  final Set<int> bookmarks;

  LibrarySectionProgress copyWith({
    int? lastIndex,
    bool? completed,
    Set<int>? bookmarks,
  }) {
    return LibrarySectionProgress(
      lastIndex: lastIndex ?? this.lastIndex,
      completed: completed ?? this.completed,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  factory LibrarySectionProgress.fromJson(Map<String, dynamic> json) {
    final rawBookmarks = json['bookmarks'];
    return LibrarySectionProgress(
      lastIndex: json['lastIndex'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      bookmarks: rawBookmarks is List
          ? rawBookmarks.map((e) => e as int).toSet()
          : const <int>{},
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lastIndex': lastIndex,
        'completed': completed,
        'bookmarks': bookmarks.toList()..sort(),
      };
}
