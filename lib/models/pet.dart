class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String imageUrl;

  /// Optional profile fields collected in `AddPetProfileScreen`.
  final String? gender;
  final String? size;
  final String? birthDate; // dd/MM/yyyy (keeps current UI format)

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.imageUrl = '',
    this.gender,
    this.size,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'age': age,
        'imageUrl': imageUrl,
        'gender': gender,
        'size': size,
        'birthDate': birthDate,
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'],
        name: json['name'],
        species: json['species'],
        breed: json['breed'],
        age: (json['age'] as num).toInt(),
        imageUrl: json['imageUrl'] ?? '',
        gender: json['gender'],
        size: json['size'],
        birthDate: json['birthDate'],
      );
}

