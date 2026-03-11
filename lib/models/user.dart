class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final List<String> petIds;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImageUrl,
    this.petIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'phone': phone,
        'profileImageUrl': profileImageUrl,
        'petIds': petIds,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        phone: json['phone'],
        profileImageUrl: json['profileImageUrl'],
        petIds: json['petIds'] ?? [],
      );
}
