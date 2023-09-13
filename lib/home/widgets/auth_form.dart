// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, {super.key});

  final void Function(
    String Email,
    String Password,
    String UserNickName,
    String Username,
    String Surname,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userNickName = '';
  var _userPassword = '';
  var _userName = '';
  var _userSurname = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userNickName.trim(),
        _userName.trim(),
        _userSurname.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.only(left: 0.0, right: 00.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset("assets/wordwise.png"),
                  TextFormField(
                    key: const ValueKey('Email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(30)),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('Username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return "Please enter at least 6 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onSaved: (value) {
                        _userNickName = value!;
                      },
                    ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('Password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(30)),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a valid name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  const SizedBox(height: 12),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('Surname'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a valid surname";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "Surname",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onSaved: (value) {
                        _userSurname = value!;
                      },
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? "Login" : "Signup"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    child: Text(_isLogin
                        ? "Create a New Account"
                        : 'I Already Have an Account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
