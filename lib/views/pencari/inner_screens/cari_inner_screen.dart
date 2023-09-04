import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infokos/views/pencari/kosDetail/kos_detail_screen.dart';

class CariInnerScreen extends StatefulWidget {
  const CariInnerScreen({super.key});

  @override
  _CariInnerScreenState createState() => _CariInnerScreenState();
}

class _CariInnerScreenState extends State<CariInnerScreen> {
  String _cariValue = '';
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> kosStream = FirebaseFirestore.instance
        .collection('kos')
        .where('disetujui', isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, // warna tombol back
        ),
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              _cariValue = value;
            });
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: 'Cari kos disini',
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
      body: _cariValue == ''
          ? const Center(
              child: Text(
                'Cari Kos',
                style: TextStyle(fontSize: 20),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: kosStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                final cariData = snapshot.data!.docs.where((element) {
                  return element['namaKos']
                          .toLowerCase()
                          .contains(_cariValue.toLowerCase()) ||
                      element['alamat']
                          .toLowerCase()
                          .contains(_cariValue.toLowerCase()) ||
                      element['kecamatan']
                          .toLowerCase()
                          .contains(_cariValue.toLowerCase());
                });
                return SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cariData.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return KosDetailScreen(kosData: e);
                            }));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: Container(
                                    height: 130,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          e['imageUrlList'][0],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                e['jenis'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${'Sisa ' + e['jlhKamar']} Kamar',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          e['namaKos'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined,
                                              size: 16, color: Colors.black),
                                          const SizedBox(width: 5),
                                          Text(
                                            e['kecamatan'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          e['fasUmum'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Text(
                                        '${'Rp.' + e['harga']}/bulan',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
