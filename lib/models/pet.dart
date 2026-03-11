class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String imageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'age': age,
        'imageUrl': imageUrl,
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'],
        name: json['name'],
        species: json['species'],
        breed: json['breed'],
        age: json['age'],
        imageUrl: json['imageUrl'] ?? '',
      );
}
