import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infokos/views/pencari/nav_screen/cari_screen.dart';
import 'package:infokos/views/pencari/nav_screen/favorit_screen.dart';
import 'package:infokos/views/pencari/nav_screen/home_screen.dart';
import 'package:infokos/views/pencari/nav_screen/profil_pencari_screen.dart';
import 'package:flutter/services.dart';

class MainPencariScreen extends StatefulWidget {
  const MainPencariScreen({super.key});

  @override
  State<MainPencariScreen> createState() => _MainPencariScreenState();
}

class _MainPencariScreenState extends State<MainPencariScreen> {
  DateTime timeBackPressed = DateTime.now();
  
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const HomePencariScreen(),
    const CariScreen(),
    const FavoritScreen(),
    ProfilPencariScreen(),
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
                  icon: Icon(CupertinoIcons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search), label: 'Cari'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_favorites_alt),
                  label: 'Favorit'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled), label: 'Profil'),
            ],
          ),
          body: _pages[_pageIndex],
        ),
      );
}
