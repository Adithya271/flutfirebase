import 'package:flutter/material.dart';
import 'package:infokos/controllers/auth_pemilik_controller.dart';
import 'package:infokos/utils/show_snackBar.dart';
import 'package:infokos/views/pemilik/auth/login_pemilik_screen.dart';

class RegisterPemilikScreen extends StatefulWidget {
  const RegisterPemilikScreen({super.key});

  @override
  State<RegisterPemilikScreen> createState() => _RegisterPemilikScreenState();
}

class _RegisterPemilikScreenState extends State<RegisterPemilikScreen> {
  final AuthPemilikController _authController = AuthPemilikController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String nama;

  late String nomorHp;

  late String password;

  bool _isLoading = false;

 _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        bool emailExists = await _authController.checkIfEmailExists(email);
        if (emailExists) {
          setState(() {
            _isLoading = false;
          });
          showSnack(context, 'Email sudah terpakai');
        } else {
          String res = await _authController.signUpPemilik(
              email, nama, nomorHp, password);
          setState(() {
            _formKey.currentState!.reset();
            _isLoading = false;
          });
          showSnack(context, 'Selamat Akun Anda Telah Dibuat');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnack(context, 'Error: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnack(context, 'Data tidak boleh kosong!');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Daftar Akun Pemilik Kos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Image(
                  image: AssetImage('assets/images/Daftar.png'),
                  width: 120,
                  height: 120,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      nama = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama lengkap sesuai identitas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Nama Lengkap',
                      labelStyle: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nomor HP tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      nomorHp = '+62$value';
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Isi dengan nomor handphone yang aktif',
                      prefixText: '+62 ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Nomor Handphone',
                      labelStyle: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan email untuk akun infokos',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan password untuk akun infokos',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _signUpUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
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
                    const Text('Sudah Punya Akun Infokos?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginPemilikScreen();
                        }));
                      },
                      child: const Text('Login disini'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
