import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordie_1/constant.dart';

import 'package:http/http.dart' as http;
import 'package:wordie_1/firebase_auth.dart';
import 'package:wordie_1/models/new_word_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainArea extends StatefulWidget {
  const MainArea({super.key});

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = Auth().currentUser;

  Widget _userUid() {
    return Text(user?.uid ?? 'User email');
  }

  List<NewWordModel> newWordList = [];
  //apiden cekilen kelimeler once burada toplanıyor.
  // ignore: non_constant_identifier_names
  List<NewWordModel> LearntWordList = [];

  int count = 0;

  //bool _enabled = true;

  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await getWordList();

      setState(() {
        isInit = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getUserWords();

    return isInit
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _userUid(),
                //_signOutButton(),
                const SizedBox(height: 35),
                const Text(
                  "Click the icon if you understand this word!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                //_userUid(),

                _iconButton(context),

                Text(
                  newWordList[count].name.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 35),
                Expanded(
                  child: Text(
                    newWordList[count].description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            setState(() {
                              if (count > 0) count--;
                            });
                          },
                          child: const Text(
                            'Previous Word',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              if (newWordList.length - 1 > count) count++;
                            });
                          },
                          child: const Text(
                            'Next Word',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )
              ],
            ));
  }

  void getUserWords() {
    Query LearntWordsByUser = FirebaseFirestore.instance
        .collection("Words")
        .where("uid", isEqualTo: auth.currentUser!.uid);
    LearntWordsByUser.snapshots();
  }

  Widget _iconButton(context) {
    return IconButton(
      icon: Image.asset("assets/wordwise.png"),
      iconSize: 300,
      onPressed: () {
        setState(
          () {
            FirebaseFirestore.instance.collection("Words").doc().set(
              {
                "Word": newWordList[count].name,
                "Description": newWordList[count].description,
                "uid": user?.uid ?? 'User email',
              },
            );
            newWordList.removeAt(count);
            if (newWordList.length - 1 < count) count--;
          },
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Congrats!",
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "You can check this word again in the profile section if you want.",
                textAlign: TextAlign.center,
              ),
              //title: Text(newWordList[count].name),
              //content: Text(newWordList[count].description),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 115),
                  child: MaterialButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> getWordList() async {
    for (var wordName in wordNameList) {
      var url = Uri.parse(baseUrl + wordName);
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      NewWordModel newWordModel = NewWordModel(
          name: data[0]["word"],
          description: data[0]["meanings"][0]["definitions"][0]["definition"]);
      newWordList.add(newWordModel);
    }
  }
}
