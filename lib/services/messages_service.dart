import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _messagesCollection =>
      _firestore.collection('messages');

  Future<void> addPetMessage({
    required String userId,
    required String petId,
    required String petName,
    required String message,
  }) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'userId': userId,
      'petId': petId,
      'petName': petName,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> messagesForPet({
    required String petId,
  }) {
    // First: don't depend on serverTimestamp ordering.
    // Some reads can temporarily return empty if createdAt isn't present yet.
    return FirebaseFirestore.instance
        .collection('messages')
        .where('petId', isEqualTo: petId)
        .snapshots()
        .map((snapshot) {
      // Client-side sort when createdAt exists.
      final docs = snapshot.docs.map((d) => d.data()).toList();
      docs.sort((a, b) {
        final aTs = a['createdAt'];
        final bTs = b['createdAt'];
        if (aTs is Timestamp && bTs is Timestamp) {
          return bTs.compareTo(aTs); // descending
        }
        if (aTs is Timestamp) return -1;
        if (bTs is Timestamp) return 1;
        return 0;
      });
      return docs;
    });
  }

}

