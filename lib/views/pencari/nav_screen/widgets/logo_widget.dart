import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              'assets/images/logo.png',
              width: 30,
            ),
          ),
          const SizedBox(width: 3),
          Container(
            child: Image.asset(
              'assets/images/infokos.png',
              width: 70,
            ),
          ),
        ],
      ),
    );
  }
}
