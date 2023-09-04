import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../inner_screens/cari_inner_screen.dart';

class CariInputWidget extends StatelessWidget {
  const CariInputWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2), // ganti warna shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CariInnerScreen()),
              );
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Cari kos disini',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
