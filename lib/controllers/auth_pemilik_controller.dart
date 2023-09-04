import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPemilikController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpPemilik(
      String email, String nama, String nomorHp, String password) async {
    try {
      if (email.isNotEmpty &&
          nama.isNotEmpty &&
          nomorHp.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _firestore.collection('user_pemilik').doc(cred.user!.uid).set({
          'email': email,
          'nama': nama,
          'nomorHp': nomorHp,
          'pemilikId': cred.user!.uid,
          'profilGambar': '',
        });

        return 'success';
      } else {
        return 'Data Harus Diisi!';
      }
    } catch (e) {
      // Handle any exceptions thrown by Firebase Authentication or Firestore
      return 'Terjadi Kesalahan!';
    }
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


  //fungsi login pemilik
  loginPemilik(String email, String password) async {
    String res = 'terjadi kesalahan';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Memeriksa apakah email berasal dari koleksi 'user_pemilik'
        var userDoc = await _firestore
            .collection('user_pemilik')
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
