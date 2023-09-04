import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/home_kos.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/main_kos_widget.dart';

class PromosiWidget extends StatefulWidget {
  const PromosiWidget({super.key});

  @override
  State<PromosiWidget> createState() => _PromosiWidgetState();
}

class _PromosiWidgetState extends State<PromosiWidget> {
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> filterStream =
        FirebaseFirestore.instance.collection('kecamatan').snapshots();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding:
              EdgeInsets.only(top: 3.0, bottom: 0.0, left: 20.0, right: 20.0),
          child: Text(
            'Promo Kos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: filterStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Terjadi kesalahan');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Loading...."),
              );
            }

            List<DropdownMenuItem<String>> dropdownItems = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final filterData = snapshot.data!.docs[i];
              String namaKecamatan = filterData['namaKecamatan'];
              dropdownItems.add(
                DropdownMenuItem(
                  value: namaKecamatan,
                  child: Text(
                    namaKecamatan,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            dropdownItems.insert(
              0,
              const DropdownMenuItem(
                value: null,
                child: Text(
                  'Semua Kecamatan',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            );

            return Padding(
              padding: const EdgeInsets.only(
                  top: 6.0, bottom: 15.0, left: 20.0, right: 20.0),
              child: SizedBox(
                height: 38,
                child: Row(children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedFilter,
                      items: dropdownItems,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value;
                        });
                        print(_selectedFilter);
                      },
                      hint: const Text(
                        'Pilih Kecamatan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
        if (_selectedFilter == null || _selectedFilter == '')
          const MainKosWidget()
        else if (_selectedFilter != null && _selectedFilter != '')
          HomeKosWidget(namaKecamatan: _selectedFilter!),
      ],
    );
  }
}
