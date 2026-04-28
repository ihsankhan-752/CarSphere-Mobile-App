import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/listing_model.dart';
import '../data/services/listing_service.dart';
import '../data/services/favorite_service.dart';

class CarProvider extends ChangeNotifier {
  final ListingService _listingService = ListingService();
  final FavoriteService _favoriteService = FavoriteService();
  List<ListingModel> _listings = [];
  List<ListingModel> _favorites = [];
  List<ListingModel> _myListings = [];
  bool _isLoading = false;
  String? _error;

  List<ListingModel> get listings => _listings;
  List<ListingModel> get favorites => _favorites;
  List<ListingModel> get myListings => _myListings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CarProvider() {
    fetchListings();
  }

  Future<void> fetchListings({Map<String, String>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _listings = await _listingService.getListings(filters: filters);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyListings(String userId) async {
    // Note: This assumes the backend supports filtering by sellerId
    try {
      _myListings = await _listingService.getListings(filters: {'sellerId': userId});
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error fetching my listings: $e');
    }
  }

  Future<void> fetchFavorites(String token) async {
    try {
      _favorites = await _favoriteService.getFavorites(token);
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error fetching favorites: $e');
    }
  }

  Future<bool> addListing(Map<String, dynamic> data, String token, {List<XFile>? images}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newListing = await _listingService.createListing(data, token, images: images);
      _listings.insert(0, newListing);
      _myListings.insert(0, newListing); // Also add to my listings
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(String listingId) {
    return _favorites.any((l) => l.id == listingId);
  }

  Future<void> toggleFavorite(String listingId, String token) async {
    try {
      final favoriteIndex = _favorites.indexWhere((l) => l.id == listingId);
      
      if (favoriteIndex != -1) {
        // Remove from favorites
        final favoriteId = _favorites[favoriteIndex].favoriteId;
        if (favoriteId != null) {
          await _favoriteService.removeFavorite(favoriteId, token);
          _favorites.removeAt(favoriteIndex);
          notifyListeners();
        } else {
          await fetchFavorites(token);
        }
      } else {
        // Add to favorites
        await _favoriteService.addFavorite(listingId, token);
        await fetchFavorites(token);
      }
    } catch (e) {
      print('DEBUG: Error toggling favorite: $e');
      await fetchFavorites(token);
    }
  }

  Future<bool> sendInquiry(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _listingService.sendInquiry(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
