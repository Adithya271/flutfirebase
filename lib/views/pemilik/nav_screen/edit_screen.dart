import 'package:flutter/material.dart';
import 'package:infokos/views/pemilik/nav_screen/edit_kos_tabs/belum_publish.dart';
import 'package:infokos/views/pemilik/nav_screen/edit_kos_tabs/sudah_publish.dart';

class EditPemilikScreen extends StatelessWidget {
  const EditPemilikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.yellow.shade900,
            title: const Text(
              'Edit Kos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                child: Text('Sudah Dipublish'),
              ),
              Tab(
                child: Text('Belum Dipublish'),
              )
            ]),
          ),

          body: TabBarView(children: [
            SudahPublishTab(),

            BelumPublishTab(),
          ]),
        ),
        );
  }
}
