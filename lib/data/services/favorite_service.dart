import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/listing_model.dart';
import '../../core/constants/api_config.dart';

class FavoriteService {
  Future<List<ListingModel>> getFavorites(String token) async {
    final url = Uri.parse(ApiConfig.favoriteBase);
    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 7));

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
        throw Exception('Failed to fetch favorites');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addFavorite(
    String listingId,
    String token,
  ) async {
    final url = Uri.parse(ApiConfig.favoriteBase);
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'listingId': listingId}),
          )
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['data'] ?? decoded;
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Failed to add to favorites');
        } catch (_) {
          throw Exception(
              'Failed to add to favorites (Status ${response.statusCode})');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(String favoriteId, String token) async {
    final url = Uri.parse('${ApiConfig.favoriteBase}/$favoriteId');
    try {
      final response = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 7));

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      rethrow;
    }
  }
}
