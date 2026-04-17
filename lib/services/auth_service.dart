import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // TODO: Implement authentication logic
  // This is a placeholder for authentication functionality
  
  Future<app_user.User?> login(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await _saveUserToFirestore(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
          profileImageUrl: firebaseUser.photoURL,
        );
        return app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
          profileImageUrl: firebaseUser.photoURL,
        );
      }
      return null;
    } catch (e) {
      print('Email login error: $e');
      return null;
    }
  }

  Future<app_user.User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _saveUserToFirestore(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
          profileImageUrl: firebaseUser.photoURL,
        );
        return app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
          profileImageUrl: firebaseUser.photoURL,
        );
      }
      return null;
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
    return null;
  }

  Future<app_user.User?> register(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await _saveUserToFirestore(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: name,
          profileImageUrl: firebaseUser.photoURL,
        );
        return app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: name,
          profileImageUrl: firebaseUser.photoURL,
        );
      }
      return null;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<app_user.User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return app_user.User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
        profileImageUrl: user.photoURL,
      );
    }
    return null;
  }

  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    required String name,
    String? phone,
    String? profileImageUrl,
  }) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final userData = app_user.User(
        id: uid,
        email: email,
        name: name,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
      await userDoc.set(userData.toJson());
      print('User document created/updated for UID: $uid');
    } catch (e) {
      print('Firestore save error: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
