import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/listing_model.dart';

class FavoriteService {
  // Trying without trailing slash as primary, but will log more details
  static const String baseUrl = 'http://10.0.2.2:8000/favourite';

  Future<List<ListingModel>> getFavorites(String token) async {
    final url = Uri.parse(baseUrl);
    print('DEBUG: GET Favorites from $url');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 7));

      print('DEBUG: getFavorites status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> list = [];
        if (decoded is Map && decoded.containsKey('data')) {
          list = decoded['data'];
        } else if (decoded is List) {
          list = decoded;
        }
        return list.map((json) => ListingModel.fromJson(json)).toList();
      } else {
        print('DEBUG: getFavorites error body: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');
        throw Exception('Failed to fetch favorites');
      }
    } catch (e) {
      print('DEBUG: Error in getFavorites: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addFavorite(String listingId, String token) async {
    final url = Uri.parse(baseUrl);
    print('DEBUG: POST Favorite to $url with listingId: $listingId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'listingId': listingId}),
      ).timeout(const Duration(seconds: 7));

      print('DEBUG: addFavorite status: ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['data'] ?? decoded;
      } else {
        print('DEBUG: addFavorite error body: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Failed to add to favorites');
        } catch (_) {
          throw Exception('Failed to add to favorites (Status ${response.statusCode})');
        }
      }
    } catch (e) {
      print('DEBUG: Error in addFavorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String favoriteId, String token) async {
    final url = Uri.parse('$baseUrl/$favoriteId');
    print('DEBUG: DELETE Favorite at $url');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 7));

      print('DEBUG: removeFavorite status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('DEBUG: removeFavorite error body: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      print('DEBUG: Error in removeFavorite: $e');
      rethrow;
    }
  }
}
