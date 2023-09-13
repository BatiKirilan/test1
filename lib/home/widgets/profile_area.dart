import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordie_1/auth_screen.dart';
import 'package:wordie_1/firebase_auth.dart';

class ProfileAreas extends StatefulWidget {
  const ProfileAreas({super.key});

  @override
  State<ProfileAreas> createState() => _ProfileAreasState();
}

class _ProfileAreasState extends State<ProfileAreas> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = Auth().currentUser;

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  var _userEmail = '';
  var _userNickName = '';
  var _userName = '';
  var _userSurname = '';

  var fieldEmail = "";
  var fieldUsername = "";
  var fieldName = "";
  var fieldSurname = "";

  String? userEmail, userNickname, userPassword, userRealname, userSurname;

  getUserEmail(email) {
    userEmail = email;
  }

  // getUserPassword(password) {
  // userPassword = password;
  //}

  getUserNickname(username) {
    userNickname = username;
  }

  getUserRealname(name) {
    userRealname = name;
  }

  getUserSurname(surname) {
    userSurname = surname;
  }

  showData() {
    FirebaseFirestore.instance
        .collection("NewUsers")
        .doc(user?.uid)
        .get()
        .then((thatData) => setState((() {
              fieldEmail = thatData.data()!["Email"];
              fieldUsername = thatData.data()!["Username"];
              fieldName = thatData.data()!["Name"];
              fieldSurname = thatData.data()!["Surname"];
            })));
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("NewUsers").doc(user?.uid);
    Map<String, dynamic> users = {
      "Email": userEmail,
      "Username": userNickname,
      "Name": userRealname,
      "Surname": userSurname,
    };
//null gitmemesi gerekiyor zorunluluk eklenmiyor
    documentReference.set(users).whenComplete(() {
      print("$userEmail updated");
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: Column(children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        _userUid(),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Your Informations",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Expanded(child: UserInformation()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Enter your Email",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty || !value.contains("@")) {
                return "Please enter a valid email address.";
              }
              return null;
            },
            onSaved: (value) {
              _userEmail = value!;
            },
            onChanged: (String email) {
              getUserEmail(email);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Change Username",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 2.0,
                ),
              ),
            ),
            onSaved: (value) {
              _userNickName = value!;
            },
            key: const ValueKey('Username'),
            validator: (value) {
              if (value!.isEmpty || value.length < 6) {
                return "Please enter at least 6 characters";
              }
              return null;
            },
            onChanged: (String username) {
              getUserNickname(username);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: const ValueKey('Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter a valid name";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Change Name",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 2.0,
                ),
              ),
            ),
            onSaved: (value) {
              _userName = value!;
            },
            onChanged: (String name) {
              getUserRealname(name);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: const ValueKey('Surname'),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter a valid surname";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Change Surname",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 2.0,
                ),
              ),
            ),
            onSaved: (value) {
              _userSurname = value!;
            },
            onChanged: (String surname) {
              getUserSurname(surname);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              child: const Text("Update Changes"),
              onPressed: () {
                updateData();
              },
            ),
          ],
        ),
        const Divider(
          height: 10,
          thickness: 5,
        ),
        const Text(
          "Learnt Words",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        Expanded(child: UserWords()),
      ]),
    );
  }
}

class UserWords extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Query LearntWordsByUser = FirebaseFirestore.instance
        .collection("Words")
        .where("uid", isEqualTo: auth.currentUser!.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: LearntWordsByUser.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['Word']),
              subtitle: Text(data['Description']),
            );
          }).toList(),
        );
      },
    );
  }
}

class UserInformation extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Query UserInfos = FirebaseFirestore.instance
        .collection("NewUsers")
        .where("Email", isEqualTo: auth.currentUser!.email);

    return StreamBuilder<QuerySnapshot>(
      stream: UserInfos.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['Name']),
              subtitle: Text(data['Surname']),
              leading: Text(data["Email"]),
              trailing: Text(data["Username"]),
            );
          }).toList(),
        );
      },
    );
  }
}
