import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infokos/utils/login_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/pemilik/main_pemilik_screen.dart';
import '../views/pencari/main_pencari_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    mulaiSplashScreen();
  }

 mulaiSplashScreen() async {
    var duration = const Duration(seconds: 2);

    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is already logged in
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;

      // Check if the user is a user_pemilik
      DocumentSnapshot pemilikSnapshot = await FirebaseFirestore.instance
          .collection('user_pemilik')
          .doc(uid)
          .get();
      if (pemilikSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            return const MainPemilikScreen();
          }),
        );
        return;
      }

      // Check if the user is a user_pencari
      DocumentSnapshot pencariSnapshot = await FirebaseFirestore.instance
          .collection('user_pencari')
          .doc(uid)
          .get();
      if (pencariSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            return const MainPencariScreen();
          }),
        );
        return;
      }
    }

    // If the user is not logged in, navigate to the LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return const LoginRoleScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 70,
                child: SizedBox(
                    height: 110,
                    width: 110,
                    child: Image.asset("assets/images/logo.png"))),
            Positioned(
                left: 0,
                right: 0,
                top: 95,
                bottom: 0,
                child: SizedBox(
                    height: 110,
                    width: 110,
                    child: Image.asset("assets/images/infokos.png"))),
          ],
        )),
      ),
    );
  }
}
