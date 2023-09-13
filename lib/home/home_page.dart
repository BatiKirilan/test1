import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wordie_1/home/widgets/main_area.dart';
import 'package:wordie_1/home/widgets/profile_area.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: camel_case_types
class _HomePageState extends State<HomePage> {
  int index = 0;

  List screens = [
    const MainArea(),
    const ProfileAreas(),
  ];

  final items = <Widget>[
    const Icon(
      Icons.home,
      color: Colors.white,
      size: 30,
    ),
    const Icon(
      Icons.perm_identity,
      color: Colors.white,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepPurpleAccent,
      bottomNavigationBar: buildBottomNavigatorBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          DropdownButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                value: "logout",
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
        //title: const Text('Home'),
      ),
      body: screens[index],
    );
  }

  SingleChildScrollView buildBottomNavigatorBar() {
    return SingleChildScrollView(
      child: CurvedNavigationBar(
        height: 60,
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
        backgroundColor: Colors.transparent,
        color: Colors.deepPurpleAccent,
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
