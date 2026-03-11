class PetService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final double rating;

  PetService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl = '',
    this.rating = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'rating': rating,
      };

  factory PetService.fromJson(Map<String, dynamic> json) => PetService(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'].toDouble(),
        category: json['category'],
        imageUrl: json['imageUrl'] ?? '',
        rating: json['rating']?.toDouble() ?? 0.0,
      );
}
