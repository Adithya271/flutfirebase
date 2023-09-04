import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/cari_input_widget.dart';
import 'package:infokos/views/pencari/inner_screens/all_kos_screen.dart';

class CariScreen extends StatelessWidget {
  const CariScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> filterStream =
        FirebaseFirestore.instance.collection('kecamatan').snapshots();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Padding(
              padding: EdgeInsets.all(8.0), child: CariInputWidget()),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: filterStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final filterData = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 15, right: 15, bottom: 8),
                      child: SizedBox(
                        height: 50,
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AllKosScreen(
                                  filterData: filterData,
                                );
                              }));
                            },
                            title: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 2, right: 0, bottom: 5),
                              child: Text(
                                filterData['namaKecamatan'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
