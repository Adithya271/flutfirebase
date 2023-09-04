import 'package:flutter/material.dart';
import 'package:infokos/views/pemilik/nav_screen/tambah_screen.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selamat Datang Pemilik Kos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 100),
          const Text(
            'Waktunya Mengelola Properti',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Tambah Properti',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Buat dan Kelola Kos Anda',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
