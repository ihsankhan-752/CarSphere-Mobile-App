class ListingModel {
  final String id;
  final String? favoriteId;
  final String sellerId;
  final String title;
  final String description;
  final String company;
  final String model;
  final double price;
  final int mileage;
  final String fuelType;
  final String transmission;
  final String color;
  final List<String> images;
  final String status;
  final DateTime createdAt;

  ListingModel({
    required this.id,
    this.favoriteId,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.company,
    required this.model,
    required this.price,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.color,
    required this.images,
    required this.status,
    required this.createdAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    // If it's from the favorites join table, 'id' is the favoriteId and 'listingId' is the carId
    final isFavoriteItem = json.containsKey('listingId');
    final carId = isFavoriteItem ? json['listingId'].toString() : (json['id']?.toString() ?? '');
    final favId = isFavoriteItem ? json['id'].toString() : null;

    return ListingModel(
      id: carId,
      favoriteId: favId,
      sellerId: json['sellerId']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      model: json['model'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      mileage: int.tryParse(json['mileage'].toString()) ?? 0,
      fuelType: json['fuelType'] ?? 'petrol',
      transmission: json['transmission'] ?? 'automatic',
      color: json['color'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'company': company,
      'model': model,
      'price': price,
      'mileage': mileage,
      'fuelType': fuelType,
      'transmission': transmission,
      'color': color,
      'images': images,
    };
  }

  String get fullName => '$company $model';
  
  String get formattedPrice => '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
}
