import 'package:flutter/material.dart';

class SemuaFotoKosDetail extends StatefulWidget {
  final dynamic kosData;
  const SemuaFotoKosDetail({Key? key, required this.kosData}) : super(key: key);

  @override
  State<SemuaFotoKosDetail> createState() => _SemuaFotoKosDetailState();
}

class _SemuaFotoKosDetailState extends State<SemuaFotoKosDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gambar Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: GridView.builder(
            itemCount: widget.kosData['imageUrlList'].length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                widget.kosData['imageUrlList'][index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}
