import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createPet(Pet pet) async {
    try {
      final docRef = await _firestore.collection('pets').add(pet.toJson());
      print('Pet created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating pet: $e');
      rethrow;
    }
  }

  Future<void> addPetToUser(String userId, String petId) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      await userDoc.update({
        'petIds': FieldValue.arrayUnion([petId])
      });
      print('Pet ID $petId added to user $userId');
    } catch (e) {
      print('Error adding pet to user: $e');
    }
  }

  Future<List<Pet>> getUserPets(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists || userDoc.data()?['petIds'] == null) {
        return [];
      }
      final petIds = List<String>.from(userDoc.data()!['petIds']);
      final pets = <Pet>[];
      for (String petId in petIds) {
        final petDoc = await _firestore.collection('pets').doc(petId).get();
        if (petDoc.exists) {
          pets.add(Pet.fromJson(petDoc.data()!));
        }
      }
      return pets;
    } catch (e) {
      print('Error getting user pets: $e');
      return [];
    }
  }
}
