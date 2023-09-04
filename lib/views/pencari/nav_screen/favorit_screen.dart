import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../kosDetail/kos_detail_screen.dart';

class FavoritScreen extends StatelessWidget {
  const FavoritScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> kosStream = FirebaseFirestore.instance
        .collection("favorit")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("kos")
        .where("emailPenambah",
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Favorit',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              color: Colors.red,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: kosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.yellow.shade800,
            ));
          }

          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: GridView.builder(
                itemCount: snapshot.data!.size,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 200 / 300),
                itemBuilder: ((context, index) {
                  final kosData = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return KosDetailScreen(
                          kosData: kosData,
                        );
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        width: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 130,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      kosData['imageUrlList'][0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 2.0,
                                              left: 10.0,
                                              right: 30.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                kosData['jenis'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 2.0,
                                              left: 4.0,
                                              right: 2.0),
                                          child: Text(
                                            '${'Sisa ' + kosData['jlhKamar']} Kamar',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 7.0,
                                          bottom: 0.0,
                                          left: 10.0,
                                          right: 30.0),
                                      child: Text(
                                        kosData['namaKos'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 0.0,
                                          left: 10.0,
                                          right: 60.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined,
                                              size: 16),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              kosData['kecamatan'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              textWidthBasis:
                                                  TextWidthBasis.parent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 0.0,
                                          left: 10.0,
                                          right: 50.0),
                                      child: Text(
                                        kosData['fasUmum'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 0.0,
                                          left: 10.0,
                                          right: 5.0),
                                      child: Text(
                                        'Rp.' +
                                            kosData['harga'] +
                                            " " +
                                            '/' +
                                            " " +
                                            'bulan',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          );
        },
      ),
    );
  }
}
