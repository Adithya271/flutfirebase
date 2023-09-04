import 'package:flutter/material.dart';
import 'package:infokos/views/pemilik/nav_screen/widgets/banner_widget.dart';
import 'package:infokos/views/pemilik/nav_screen/widgets/logo_widget.dart';
import 'package:infokos/views/pemilik/nav_screen/widgets/rekomendasi_text.dart';
import 'package:infokos/views/pemilik/nav_screen/widgets/search_input_widget.dart';
import 'package:infokos/views/pemilik/nav_screen/widgets/welcome_text_widget.dart';

class HomePemilikScreen extends StatelessWidget {
  const HomePemilikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Logo(),
        WelcomeText(),
        
       
      ],
    );
  }
}
