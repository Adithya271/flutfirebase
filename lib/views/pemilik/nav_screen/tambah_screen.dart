import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infokos/provider/kos_provider.dart';
import 'package:infokos/utils/show_snackBar.dart';
import 'package:infokos/views/pemilik/main_pemilik_screen.dart';
import 'package:infokos/views/pemilik/nav_screen/tambah_tab_screens/data_kos_tab_screen.dart';
import 'package:infokos/views/pemilik/nav_screen/tambah_tab_screens/images_tab_scrrens.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TambahScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TambahScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final KosProvider kosProvider = Provider.of<KosProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const Text(
              'Tambah Kos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                child: Text('Data Kos'),
              ),
              Tab(
                child: Text('Gambar'),
              ),
            ]),
          ),
          body: const TabBarView(
            children: [
              DataKosTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                EasyLoading.show(status: 'Tunggu Sebentar...');
                if (_formKey.currentState!.validate()) {
                  final kosId = const Uuid().v4();
                  await _firestore.collection('kos').doc(kosId).set({
                    'kosId': kosId,
                    'namaKos': kosProvider.kosData['namaKos'],
                    'jenis': kosProvider.kosData['jenis'],
                    'jlhKamar': kosProvider.kosData['jlhKamar'],
                    'kecamatan': kosProvider.kosData['namaKecamatan'],
                    'alamat': kosProvider.kosData['alamat'],
                    'tipe': kosProvider.kosData['tipe'],
                    'isPromo': kosProvider.kosData['isPromo'],
                    'harga': kosProvider.kosData['harga'],
                    'spek_tipekamar': kosProvider.kosData['spek_tipekamar'],
                    'fasKamar': kosProvider.kosData['fasKamar'],
                    'fasKamarmandi': kosProvider.kosData['fasKamarmandi'],
                    'peraturan': kosProvider.kosData['peraturan'],
                    'fasUmum': kosProvider.kosData['fasUmum'],
                    'fasParkir': kosProvider.kosData['fasParkir'],
                    'cerita': kosProvider.kosData['cerita'],
                    'lokasi': kosProvider.kosData['lokasi'],
                    'imageUrlList': kosProvider.kosData['imageUrlList'],
                    'pemilikId': FirebaseAuth.instance.currentUser!.uid,
                    'disetujui': false,
                  }).whenComplete(() {
                    kosProvider.clearData();
                    _formKey.currentState!.reset();
                    EasyLoading.dismiss();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MainPemilikScreen();
                    }));
                  });
                } else {
                  EasyLoading.dismiss();
                  return showSnack(context, 'Data tidak boleh kosong!');
                }
              },
              child: const Text('Simpan Data Kos'),
            ),
          ),
        ),
      ),
    );
  }
}
