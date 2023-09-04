import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class EditPencariProfilScreen extends StatefulWidget {
  final dynamic pencariData;

  const EditPencariProfilScreen({super.key, required this.pencariData});

  @override
  State<EditPencariProfilScreen> createState() =>
      _EditPencariProfilScreenState();
}

class _EditPencariProfilScreenState extends State<EditPencariProfilScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _namaController = TextEditingController();

  final TextEditingController _nomorhpController = TextEditingController();

  final picker = ImagePicker();
  File? _image;

  String? alamat;
  String? jenis_kelamin;
  String? profesi;
  String? tgl_lahir;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('profilGambar/$fileName');

      // Upload the image to Firebase Storage
      TaskSnapshot taskSnapshot = await reference.putFile(imageFile);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  @override
  void initState() {
    setState(() {
      _namaController.text = widget.pencariData['nama'];

      _nomorhpController.text =  widget.pencariData['nomorHp'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.yellow.shade800,
                      backgroundImage: _image != null
                          ? Image.file(_image!).image
                          : widget.pencariData['profilGambar'] != null
                              ? NetworkImage(widget.pencariData['profilGambar'])
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: const Icon(
                          CupertinoIcons.photo_camera_solid,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Nama',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _nomorhpController,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Nomor Handphone',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) {
                      alamat = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Alamat(Optional)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) {
                      jenis_kelamin = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Jenis Kelamin(Optional)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) {
                      profesi = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Profesi(Optional)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) {
                      tgl_lahir = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Tanggal Lahir(Optional)',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'SEDANG MENGUPDATE');

            // Upload gambar tsb jika tidak null
            String? imageUrl;
            if (_image != null) {
              imageUrl = await uploadImageToStorage(_image!);
            }

            await _firestore
                .collection('user_pencari')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'nama': _namaController.text,
              'nomorHp': _nomorhpController.text,
              'alamat': alamat,
              'jenis_kelamin': jenis_kelamin,
              'profesi': profesi,
              'tgl_lahir': tgl_lahir,
              'profilGambar': imageUrl
            }).whenComplete(() {
              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.yellow.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                    color: Colors.white, fontSize: 18, letterSpacing: 6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
