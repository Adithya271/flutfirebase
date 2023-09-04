import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPencariController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //fungsi signup pencari
  Future<String> signUpPencari(
      String email, String nama, String nomorHp, String password) async {
    String res = 'Terjadi Kesalahan!';

    try {
      if (email.isNotEmpty &&
          nama.isNotEmpty &&
          nomorHp.isNotEmpty &&
          password.isNotEmpty) {
        //Buat user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _firestore.collection('user_pencari').doc(cred.user!.uid).set({
          'email': email,
          'nama': nama,
          'nomorHp': nomorHp,
          'pencariId': cred.user!.uid,
          'jenis_kelamin': '',
          'tgl_lahir': '',
          'alamat': '',
          'profesi': '',
          'profilGambar': '',
        });

        res = 'success';
      } else {
        res = 'Data Harus Diisi!';
      }
    } catch (e) {}
    return 'Terjadi Kesalahan!';
  }

  
  Future<bool> checkIfEmailExists(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else {
        throw e;
      }
    }
  }

  //fungsi login pencari
  loginPencari(String email, String password) async {
    String res = 'terjadi kesalahan';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Memeriksa apakah email berasal dari koleksi 'user_pencari'
        var userDoc = await _firestore
            .collection('user_pencari')
            .where('email', isEqualTo: email)
            .get();
        if (userDoc.docs.length == 1) {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          res = 'success';
        } else {
          res = 'Email Tidak Ditemukan atau Tidak Dapat Diakses';
        }
      } else {
        res = 'Data Harus Diisi';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }


  // Fungsi reset password
  Future<String> resetPassword(String email) async {
    String res = 'Terjadi Kesalahan!';

    try {
      // Cek apakah email kosong
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);

        res = 'success';
      } else {
        res = 'Email harus diisi';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
