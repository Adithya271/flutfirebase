import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infokos/provider/kos_provider.dart';
import 'package:infokos/views/pemilik/nav_screen/tambah_tab_screens/lokasi_screen.dart';
import 'package:provider/provider.dart';

class DataKosTabScreen extends StatefulWidget {
  const DataKosTabScreen({super.key});

  @override
  State<DataKosTabScreen> createState() => _DataKosTabScreenState();
}

class _DataKosTabScreenState extends State<DataKosTabScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isPromo = false;
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _jeniskosList = [];
  final List<String> _kecamatanList = [];

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
    _getJenisKos();
    _getKecamatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final KosProvider kosProvider = Provider.of<KosProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan tipe kamar kos';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(tipe: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Tipe Kamar(Contoh: Tipe A,B,C,dst)',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan nama kos';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(namaKos: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Nama Kos',
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
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan jumlah kamar';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(jlh_kamar: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Jumlah Kamar(Contoh: 0,1,2,dst)',
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
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan alamat lengkap';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(alamat: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Alamat Lengkap',
                ),
              ),
              const SizedBox(
                height: 20,
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
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan harga kamar';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(harga: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Harga Kamar',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan spesifikasi tipe kamar';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(spek_tipekamar: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Spesifikasi Tipe Kamar',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan fasilitas kamar';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(fas_kamar: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Fasilitas Kamar',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan fasilitas kamar mandi';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(fas_kamarmandi: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Fasilitas Kamar Mandi',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan peraturan khusus kamar';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(peraturan: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Peraturan Khusus Kamar',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan fasilitas umum';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(fas_umum: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Fasilitas Umum',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan fasilitas parkir';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(fas_parkir: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Masukkan Fasilitas Parkir',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'masukkan cerita pemilik kos';
                  } else {
                    return null;
                  }
                }),
                onChanged: (value) {
                  kosProvider.getFormData(cerita: value);
                },
                maxLines: 5,
                maxLength: 800,
                decoration: InputDecoration(
                  labelText: 'Masukkan Cerita Pemilik Kos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
    );
  }
}
