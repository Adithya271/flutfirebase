import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infokos/utils/login_role.dart';
import 'package:infokos/views/pencari/inner_screens/edit_pencari_profil.dart';

class ProfilPencariScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfilPencariScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('user_pencari');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Terjadi kesalahan");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Dokumen tidak tersedia");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.blue,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'Profil',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: data['profilGambar'] != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(data['profilGambar']),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.blue,
                          //Gunakan gambar default disini jika ada
                          child: Icon(Icons.person),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['nama'],
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['email'],
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 0, left: 8, right: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EditPencariProfilScreen(
                            pencariData: data,
                          );
                        },
                      ));
                    },
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 300,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade800,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'Edit Profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 2,
                    color: Color.fromARGB(255, 223, 223, 223),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(
                    
                    data['nomorHp'],
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Konfirmasi Keluar'),
                          content: const Text('Anda yakin ingin keluar?'),
                          actions: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue, // set button color
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Tidak',
                                  style: TextStyle(
                                    color: Colors.white, // set text color
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Colors.yellow.shade700, // set button color
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Ya',
                                  style: TextStyle(
                                    color: Colors.white, // set text color
                                  ),
                                ),
                                onPressed: () async {
                                  await _auth.signOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const LoginRoleScreen();
                                    }),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Keluar'),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
