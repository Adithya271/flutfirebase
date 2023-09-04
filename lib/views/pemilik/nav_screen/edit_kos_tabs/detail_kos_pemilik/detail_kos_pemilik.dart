import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infokos/provider/kos_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../tambah_tab_screens/lokasi_screen.dart';

class DetailKosPemilik extends StatefulWidget {
  final dynamic kosData;

  const DetailKosPemilik({super.key, required this.kosData});

  @override
  State<DetailKosPemilik> createState() => _DetailKosPemilikState();
}

class _DetailKosPemilikState extends State<DetailKosPemilik> {
  bool _isPromo = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _jeniskosList = [];
  final List<String> _kecamatanList = [];

  final TextEditingController _namaKosController = TextEditingController();
  final TextEditingController _alamatKosController = TextEditingController();
  final TextEditingController _ceritaKosController = TextEditingController();
  final TextEditingController _fasKamarKosController = TextEditingController();
  final TextEditingController _fasKamarmandiKosController =
      TextEditingController();
  final TextEditingController _fasParkirKosController = TextEditingController();
  final TextEditingController _fasUmumKosController = TextEditingController();
  final TextEditingController _hargaKosController = TextEditingController();
  final TextEditingController _jenisKosController = TextEditingController();
  final TextEditingController _jlhKamarKosController = TextEditingController();
  final TextEditingController _kecamatanKosController = TextEditingController();
  final TextEditingController _peraturanKosController = TextEditingController();
  final TextEditingController _spek_tipekamarKosController =
      TextEditingController();
  final TextEditingController _tipeKosController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<File> _image = [];

  final List<String> _imageUrlList = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('tidak ada gambar dipilih');
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  _getJenisKos() {
    return _firestore
        .collection('jenis_kos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _jeniskosList.add(doc['jenis']);
        });
      }
    });
  }

  _getKecamatan() {
    return _firestore
        .collection('kecamatan')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _kecamatanList.add(doc['namaKecamatan']);
        });
      }
    });
  }

  @override
  void initState() {
    setState(() {
      _getJenisKos();
      _getKecamatan();
      _namaKosController.text = widget.kosData['namaKos'];
      _alamatKosController.text = widget.kosData['alamat'];
      _ceritaKosController.text = widget.kosData['cerita'];
      _fasKamarKosController.text = widget.kosData['fasKamar'];
      _fasKamarmandiKosController.text = widget.kosData['fasKamarmandi'];
      _fasParkirKosController.text = widget.kosData['fasParkir'];
      _fasUmumKosController.text = widget.kosData['fasUmum'];
      _hargaKosController.text = widget.kosData['harga'];
      _jlhKamarKosController.text = widget.kosData['jlhKamar'];
      _peraturanKosController.text = widget.kosData['peraturan'];
      _spek_tipekamarKosController.text = widget.kosData['spek_tipekamar'];
      _tipeKosController.text = widget.kosData['tipe'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final KosProvider kosProvider = Provider.of<KosProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: Text(widget.kosData['namaKos']),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                itemCount: _image.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 3,
                ),
                itemBuilder: ((context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                              onPressed: () {
                                chooseImage();
                              },
                              icon: const Icon(Icons.add_a_photo_sharp)),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(_image[index - 1]),
                          )),
                        );
                }),
              ),
              TextButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Menyimpan Gambar');
                  for (var img in _image) {
                    Reference ref = _storage
                        .ref()
                        .child('gambarKos')
                        .child(const Uuid().v4());

                    await ref.putFile(img).whenComplete(() async {
                      await ref.getDownloadURL().then((value) {
                        setState(() {
                          _imageUrlList.add(value);
                        });
                      });
                    });
                  }
                  setState(() {
                    kosProvider.getFormData(imageUrlList: _imageUrlList);
                    EasyLoading.dismiss();
                  });
                },
                child: _image.isNotEmpty
                    ? const Text('SIMPAN GAMBAR')
                    : const Text(''),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _namaKosController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _tipeKosController,
                decoration: const InputDecoration(
                  labelText: 'Tipe Kamar Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                  hint: const Text('Masukkan Jenis Kos'),
                  items: _jeniskosList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    kosProvider.getFormData(jenis: value);
                  }),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _jlhKamarKosController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kamar Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                  hint: const Text('Masukkan Kecamatan'),
                  items: _kecamatanList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    kosProvider.getFormData(kecamatan: value);
                  }),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _alamatKosController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isPromo,
                    onChanged: (value) {
                      setState(() {
                        _isPromo = value!;
                        kosProvider.getFormData(isPromo: value);
                      });
                    },
                  ),
                  const Text('Kos Lagi Promo?'),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _hargaKosController,
                decoration: const InputDecoration(
                  labelText: 'Harga Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _spek_tipekamarKosController,
                decoration: const InputDecoration(
                  labelText: 'Spesifikasi Tipe Kamar Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _fasKamarKosController,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas Kamar Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _fasKamarmandiKosController,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas Kamar Mandi Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _peraturanKosController,
                decoration: const InputDecoration(
                  labelText: 'Peraturan Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _fasUmumKosController,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas Umum ',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _fasParkirKosController,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas Parkir Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLength: 800,
                maxLines: 3,
                controller: _ceritaKosController,
                decoration: const InputDecoration(
                  labelText: 'Cerita Pemilik Kos',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LokasiScreen(),
                    ),
                  );
                },
                child: const Text('Pilih Lokasi Kos Pada Google Map'),
              ),
              if (kosProvider.kosData['lat'] != null &&
                  kosProvider.kosData['long'] != null)
                Column(
                  children: [
                    const Text('Latitude:'),
                    Text(kosProvider.kosData['lat'].toString()),
                    const Text('Longitude:'),
                    Text(kosProvider.kosData['long'].toString()),
                  ],
                ),
              const SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'Tunggu Sebentar...');
            await _firestore
                .collection('kos')
                .doc(widget.kosData['kosId'])
                .update({
              'namaKos': _namaKosController.text,
              'alamat': _alamatKosController.text,
              'kecamatan': kosProvider.kosData['namaKecamatan'],
              'jenis': kosProvider.kosData['jenis'],
              'isPromo': kosProvider.kosData['isPromo'],
              'cerita': _ceritaKosController.text,
              'fasKamar': _fasKamarKosController.text,
              'fasKamarmandi': _fasKamarmandiKosController.text,
              'fasParkir': _fasParkirKosController.text,
              'fasUmum': _fasUmumKosController.text,
              'harga': _hargaKosController.text,
              'jlhKamar': _jlhKamarKosController.text,
              'peraturan': _peraturanKosController.text,
              'spek_tipekamar': _spek_tipekamarKosController.text,
              'tipe': _tipeKosController.text,
              'lokasi': kosProvider.kosData['lokasi'],
              'imageUrlList': kosProvider.kosData['imageUrlList'],
            }).whenComplete(() {
              kosProvider.clearData();

              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "UPDATE KOS",
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
