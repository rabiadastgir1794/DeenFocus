import 'package:deenly/core/services/native_location_search_service.dart';
import '../model/location_suggestion.dart';

class SearchPlacesUseCase {
  SearchPlacesUseCase({NativeLocationSearchService? native})
    : _native = native ?? NativeLocationSearchService();

  final NativeLocationSearchService _native;

  Future<List<LocationSuggestion>> execute(String query) {
    return _native.search(query);
  }

  /// Native search always returns coordinates; kept for call-site compatibility.
  Future<({double latitude, double longitude})?> fetchCoordinates(
    String placeId,
  ) async {
    return null;
  }
}
