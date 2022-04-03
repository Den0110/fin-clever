import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Selectable extends StatelessWidget {
  const Selectable(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: FinColor.iconBg,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Icon(icon, size: 20, color: FinColor.darkBlue),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: FinFont.medium.copyWith(fontSize: 18),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
