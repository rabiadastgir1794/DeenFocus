import '../data/places_api_client.dart';
import '../model/location_suggestion.dart';

class SearchPlacesUseCase {
  SearchPlacesUseCase({PlacesApiClient? client})
    : _client = client ?? PlacesApiClient();

  final PlacesApiClient _client;

  Future<List<LocationSuggestion>> execute(String query) {
    return _client.searchCities(query);
  }

  Future<({double latitude, double longitude})?> fetchCoordinates(
    String placeId,
  ) {
    return _client.fetchPlaceCoordinates(placeId);
  }
}
