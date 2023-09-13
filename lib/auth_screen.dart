import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordie_1/home/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  void _submitAuthForm(
    // ignore: non_constant_identifier_names
    String Email,
    // ignore: non_constant_identifier_names
    String Password,
    // ignore: non_constant_identifier_names
    String UserNickName,
    // ignore: non_constant_identifier_names
    String Username,
    // ignore: non_constant_identifier_names
    String Surname,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: Email, password: Password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: Email, password: Password);

        await FirebaseFirestore.instance
            .collection("NewUsers")
            .doc(userCredential.user?.uid)
            .set({
          "Username": UserNickName,
          "Email": Email,
          "Name": Username,
          "Surname": Surname,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
      setState(() {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
//snackbar ekrana çıkmıyor
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: AuthForm(
        _submitAuthForm,
      ),
    );
  }
}
