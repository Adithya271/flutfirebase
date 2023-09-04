import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../kosDetail/kos_detail_screen.dart';

class AllKosScreen extends StatelessWidget {
  final dynamic filterData;

  const AllKosScreen({super.key, required this.filterData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> kosStream = FirebaseFirestore.instance
        .collection('kos')
        .where('kecamatan', isEqualTo: filterData['namaKecamatan'])
        .where('disetujui', isEqualTo: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.yellow.shade800,
        title: Text(
          filterData['namaKecamatan'],
          style: const TextStyle(fontSize: 18),
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
                        width: 195,
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
                                width: 195,
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
