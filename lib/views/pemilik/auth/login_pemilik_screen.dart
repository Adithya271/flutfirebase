import 'package:flutter/material.dart';
import 'package:infokos/controllers/auth_pemilik_controller.dart';
import 'package:infokos/utils/show_snackBar.dart';
import 'package:infokos/views/pemilik/auth/register_pemilik_screen.dart';
import 'package:infokos/views/pemilik/main_pemilik_screen.dart';

import '../../../utils/reset_password.dart';

class LoginPemilikScreen extends StatefulWidget {
  const LoginPemilikScreen({super.key});

  @override
  State<LoginPemilikScreen> createState() => _LoginPemilikScreenState();
}

class _LoginPemilikScreenState extends State<LoginPemilikScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthPemilikController _authController = AuthPemilikController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      String res = await _authController.loginPemilik(email, password);

      if (res == 'success') {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const MainPemilikScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        return showSnack(context, 'Email atau password salah');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Data tidak boleh kosong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login Pemilik Kos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Tidak Boleh Kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Email Akun Infokos',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password Tidak Boleh Kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _loginUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum Punya Akun Infokos?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const RegisterPemilikScreen();
                        }));
                      },
                      child: const Text('Daftar sekarang'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Lupa Password?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ResetPasswordScreen();
                        }));
                      },
                      child: const Text(
                        'Reset password',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
