import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String Email,
    required String Password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: Email,
      password: Password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String Email,
    required String Password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: Email,
      password: Password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
