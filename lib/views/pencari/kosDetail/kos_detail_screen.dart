import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infokos/views/pencari/kosDetail/semua_foto_kos_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lokasi_screen.dart';

class KosDetailScreen extends StatefulWidget {
  final dynamic kosData;

  const KosDetailScreen({super.key, required this.kosData});

  @override
  State<KosDetailScreen> createState() => _KosDetailScreenState();
}

class _KosDetailScreenState extends State<KosDetailScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Future tambahkanFavorit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("favorit");
    return collectionRef.doc(currentUser!.email).collection("kos").doc().set({
      "namaKos": widget.kosData['namaKos'],
      "imageUrlList": widget.kosData['imageUrlList'],
      "jenis": widget.kosData['jenis'],
      "kecamatan": widget.kosData['kecamatan'],
      "alamat": widget.kosData['alamat'],
      "jlhKamar": widget.kosData['jlhKamar'],
      "spek_tipekamar": widget.kosData['spek_tipekamar'],
      "fasKamar": widget.kosData['fasKamar'],
      "fasKamarmandi": widget.kosData['fasKamarmandi'],
      "peraturan": widget.kosData['peraturan'],
      "fasUmum": widget.kosData['fasUmum'],
      "fasParkir": widget.kosData['fasParkir'],
      "cerita": widget.kosData['cerita'],
      "lokasi": widget.kosData['lokasi'],
      "harga": widget.kosData['harga'],
      "emailPenambah": currentUser.email
    }).then((value) => showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
            return const AlertDialog(
              content: Text('Kos berhasil ditambahkan ke Favorit.'),
            );
          },
        ));
  }

  void hapusFavorit(String docId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("favorit");
    await collectionRef
        .doc(currentUser!.email)
        .collection("kos")
        .doc(docId)
        .delete()
        .then((value) => showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
                return const AlertDialog(
                  content: Text('Kos berhasil dihapus dari Favorit.'),
                );
              },
            ));
  }

  Future<void> sendMessage() async {
    String pemilikId = widget.kosData['pemilikId'];
    String message =
        'Halo ${widget.kosData['namaKos']}, saya melihat iklan anda di aplikasi Infokos,Apa masih ada kamar kosong?Terima kasih ';

    // Query user_pemilik collection untuk memdapat nomorHp pemilik
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("user_pemilik");
    QuerySnapshot querySnapshot =
        await userRef.where('pemilikId', isEqualTo: pemilikId).get();

    // Dapatkan dokumen dengan matching pemilikId
    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // dapatkan nomorhp pemilik dan buka wahasapp dengan message
      String number = documentSnapshot['nomorHp'];
      await launchUrl(Uri.parse('whatsapp://send?phone=$number&text=$message'));
    } else {
      // Handle kasus ketika tidak ada dokumen ditemukan
      print('Tidak ada dokumen maatching di user_pemilik collection.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: const Color.fromARGB(255, 88, 88, 88),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("favorit")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("kos")
                .where("namaKos", isEqualTo: widget.kosData['namaKos'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => snapshot.data.docs.length == 0
                        ? tambahkanFavorit()
                        : hapusFavorit(snapshot.data.docs[0].id),
                    icon: snapshot.data.docs.length == 0
                        ? const Icon(
                            Icons.favorite_outline,
                            color: Color.fromARGB(255, 88, 88, 88),
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.kosData['imageUrlList'].length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return AspectRatio(
                            aspectRatio: 16.0 / 13.0,
                            child: Image.network(
                              widget.kosData['imageUrlList'][index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 49, 49, 49),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_currentPage + 1}/${widget.kosData['imageUrlList'].length}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SemuaFotoKosDetail(
                                      kosData: widget.kosData),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Lihat semua foto',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.kosData['namaKos'],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 15.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Kos ' + widget.kosData['jenis'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 0.0, left: 0.0, right: 60.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                widget.kosData['kecamatan'],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 2.0, left: 15.0, right: 15.0),
                  child: Text(
                    widget.kosData['alamat'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 122, 122, 122),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 2.0),
                  child: Text(
                    '${'Tersisa ' + widget.kosData['jlhKamar']}' ' Kamar',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Spesifikasi tipe kamar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['spek_tipekamar'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Fasilitas kamar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['fasKamar'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Fasilitas kamar mandi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['fasKamarmandi'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Peraturan di kos ini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['peraturan'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Fasilitas umum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['fasUmum'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Fasilitas parkir',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['fasParkir'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 20.0),
                  child: Text(
                    'Cerita pemilik tentang kos ini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 15.0, right: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kosData['cerita'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 15.0, right: 15.0),
                  child: Text(
                    'Lokasi kos dan lingkungan sekitar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 20.0, right: 15.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LokasiScreen(
                                    lokasi: widget.kosData['lokasi']),
                              ),
                            );
                          },
                          child: const Text(
                            'Lihat Peta Lokasi Kos',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 15.0, right: 2.0),
                    child: Text(
                      'Rp.' +
                          widget.kosData['harga'] +
                          " " +
                          '/' +
                          " " +
                          'bulan',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 2.0, right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await sendMessage();
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.message,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Tanya Pemilik',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
