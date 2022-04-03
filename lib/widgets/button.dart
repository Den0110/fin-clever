import 'package:flutter/material.dart';
import '../utils/constants.dart';

Widget button({required String text, required Function() onPressed}) {
  return ElevatedButton(
    child: Text(
      text,
      style: FinFont.semibold
          .copyWith(fontSize: 14, color: Colors.white),
    ),
    onPressed: onPressed,
    style: FinStyle.buttonStyle,
  );
}