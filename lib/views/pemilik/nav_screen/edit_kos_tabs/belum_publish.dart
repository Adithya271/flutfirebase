import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'detail_kos_pemilik/detail_kos_pemilik.dart';

class BelumPublishTab extends StatelessWidget {
  const BelumPublishTab({super.key});

  // method untuk menghapus data berdasarkan kosId
  void deleteData(String kosId) async {
    try {
      await FirebaseFirestore.instance.collection('kos').doc(kosId).delete();
      print('Data berhasil dihapus');
    } catch (e) {
      print('Terjadi kesalahan saat menghapus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> pemilikKosStream = FirebaseFirestore.instance
        .collection('kos')
        .where('pemilikId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('disetujui', isEqualTo: false)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: pemilikKosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                final pemilikKosData = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailKosPemilik(kosData: pemilikKosData);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        pemilikKosData['imageUrlList'].isEmpty
                            ? const Text('Tidak ada gambar')
                            : SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                    pemilikKosData['imageUrlList'][0]),
                              ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pemilikKosData['namaKos'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  pemilikKosData['tipe'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Hapus Kos'),
                                  content: const Text(
                                      'Anda yakin ingin menghapus kos ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteData(pemilikKosData.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ya',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete_forever_rounded),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
