class LocationSuggestion {
  const LocationSuggestion({
    required this.title,
    required this.subtitle,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  final String title;
  final String subtitle;
  final String? placeId;
  final double? latitude;
  final double? longitude;

  LocationSuggestion copyWith({
    String? title,
    String? subtitle,
    String? placeId,
    double? latitude,
    double? longitude,
  }) {
    return LocationSuggestion(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
