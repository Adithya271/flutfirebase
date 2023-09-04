import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infokos/views/pemilik/nav_screen/tambah_screen.dart';
import 'package:infokos/views/pemilik/nav_screen/edit_screen.dart';
import 'package:infokos/views/pemilik/nav_screen/home_screen.dart';
import 'package:infokos/views/pemilik/nav_screen/profil_pemilik_screen.dart';
import 'package:flutter/services.dart';

class MainPemilikScreen extends StatefulWidget {
  const MainPemilikScreen({super.key});

  @override
  State<MainPemilikScreen> createState() => _MainPemilikScreenState();
}

class _MainPemilikScreenState extends State<MainPemilikScreen> {
  DateTime timeBackPressed = DateTime.now();

  int _pageIndex = 0;

  final List<Widget> _pages = [
    const HomePemilikScreen(),
    TambahScreen(),
    const EditPemilikScreen(),
    ProfilPemilikScreen(),
  ];

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        

        if (isExitWarning) {
          const message = 'Tekan lagi untuk keluar';
          Fluttertoast.showToast(msg: message, fontSize: 18);
          timeBackPressed = DateTime.now();

          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();

          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.grey.shade800,
          selectedItemColor: Colors.blueAccent,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: 'Utama'),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload), label: 'Tambah Kos'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit Kos'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled), label: 'Profil'),
          ],
        ),
        body: _pages[_pageIndex],
      ));
}
