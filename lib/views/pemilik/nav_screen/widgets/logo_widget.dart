import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              'assets/images/logo.png',
              width: 30,
            ),
          ),
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
