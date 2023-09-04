import 'package:flutter/material.dart';

class RekomendasiText extends StatelessWidget {
  RekomendasiText({super.key});

  final List<String> _rekomendasilable = ['putra', 'putri', 'campur'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Rekomendasi Kos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(children: [
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _rekomendasilable.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActionChip(
                              backgroundColor: Colors.blue,
                              onPressed: () {},
                              label: Center(
                                child: Text(
                                  _rekomendasilable[index],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        );
                      })),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_ios),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
