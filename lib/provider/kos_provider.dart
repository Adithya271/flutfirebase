import 'package:flutter/material.dart';

class KosProvider with ChangeNotifier {
  Map<String, dynamic> kosData = {};

  getFormData(
      {String? namaKos,
      String? jlh_kamar,
      String? jenis,
      String? kecamatan,
      String? alamat,
      String? tipe,
      bool? isPromo,
      String? harga,
      String? spek_tipekamar,
      String? fas_kamar,
      String? fas_kamarmandi,
      String? peraturan,
      String? fas_umum,
      String? fas_parkir,
      String? cerita,
      String? lokasi,
      double? latitude,
      double? longitude,
      List<String>? imageUrlList}) {
    if (namaKos != null) {
      kosData['namaKos'] = namaKos;
    }
    if (jenis != null) {
      kosData['jenis'] = jenis;
    }
    if (jlh_kamar != null) {
      kosData['jlhKamar'] = jlh_kamar;
    }
    if (kecamatan != null) {
      kosData['namaKecamatan'] = kecamatan;
    }
    if (alamat != null) {
      kosData['alamat'] = alamat;
    }
    if (tipe != null) {
      kosData['tipe'] = tipe;
    }
    if (isPromo != null) {
      kosData['isPromo'] = isPromo;
    }
    if (harga != null) {
      kosData['harga'] = harga;
    }
    if (spek_tipekamar != null) {
      kosData['spek_tipekamar'] = spek_tipekamar;
    }
    if (fas_kamar != null) {
      kosData['fasKamar'] = fas_kamar;
    }
    if (fas_kamarmandi != null) {
      kosData['fasKamarmandi'] = fas_kamarmandi;
    }
    if (peraturan != null) {
      kosData['peraturan'] = peraturan;
    }
    if (fas_umum != null) {
      kosData['fasUmum'] = fas_umum;
    }
    if (fas_parkir != null) {
      kosData['fasParkir'] = fas_parkir;
    }
    if (cerita != null) {
      kosData['cerita'] = cerita;
    }
    if (lokasi != null) {
      kosData['lokasi'] = lokasi;
    }
    if (latitude != null) {
      kosData['lat'] = latitude;
    }
    if (longitude != null) {
      kosData['long'] = longitude;
    }
    if (imageUrlList != null) {
      kosData['imageUrlList'] = imageUrlList;
    }

    notifyListeners();
  }

  clearData() {
    kosData.clear();
    notifyListeners();
  }
}
