import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

Widget caption(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      left: FinDimen.horizontal,
      top: 16,
      right: FinDimen.horizontal,
    ),
    child: Text(
      text,
      style: FinFont.medium,
    ),
  );
}