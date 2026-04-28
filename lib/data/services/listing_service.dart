import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../models/listing_model.dart';

class ListingService {
  static const String baseUrl = 'http://10.0.2.2:8000/listing';

  Future<ListingModel> createListing(
    Map<String, dynamic> data,
    String token, {
    List<XFile>? images,
  }) async {
    final uri = Uri.parse('$baseUrl/create');
    print('DEBUG: Posting to $uri');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (images != null) {
      for (var image in images) {
        final ext = image.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png'
            ? 'image/png'
            : ext == 'webp'
            ? 'image/webp'
            : 'image/jpeg';
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }
    }

    print('DEBUG: Sending request with ${request.files.length} images');
    try {
      final streamedResponse = await request.send().timeout(const Duration(seconds: 7));
      print('DEBUG: Request sent, waiting for response...');
      final response = await http.Response.fromStream(streamedResponse);
      print('DEBUG: Response received: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ListingModel.fromJson(decoded);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create listing');
      }
    } on SocketException catch (e) {
      print('DEBUG: SocketException: $e');
      throw Exception('Server unreachable. Make sure your backend is running at $baseUrl');
    } catch (e) {
      print('DEBUG: Error during request: $e');
      rethrow;
    }
  }

  Future<List<ListingModel>> getListings({Map<String, String>? filters}) async {
    print('DEBUG: Fetching listings from $baseUrl/ with filters: $filters');
    try {
      final uri = Uri.parse('$baseUrl/').replace(queryParameters: filters);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && (decoded.containsKey('data') || decoded.containsKey('listings'))) {
          list = decoded['data'] ?? decoded['listings'];
        } else {
          print('DEBUG: Unexpected response format: $decoded');
          return [];
        }
        
        return list.map((json) => ListingModel.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch listings');
      }
    } catch (e) {
      print('DEBUG: Error in getListings: $e');
      rethrow;
    }
  }

  Future<void> deleteListing(String listingId, String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$listingId/delete"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to delete listing');
    }
  }

  Future<void> sendInquiry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inquiry'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to send inquiry');
    }
  }
}
