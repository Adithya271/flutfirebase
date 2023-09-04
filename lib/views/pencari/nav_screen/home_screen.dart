import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/banner_widget.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/logo_widget.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/promosi_widget.dart';
import 'package:infokos/views/pencari/nav_screen/widgets/welcome_text_widget.dart';

import 'widgets/cari_input_widget.dart';

class HomePencariScreen extends StatefulWidget {
  const HomePencariScreen({super.key});

  @override
  State<HomePencariScreen> createState() => _HomePencariScreenState();
}

class _HomePencariScreenState extends State<HomePencariScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Logo(),
          WelcomeText(),
          CariInputWidget(),
          BannerWidget(),
          PromosiWidget(),
        ],
      ),
    );
  }
}
