import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/constants.dart';

Widget loading() {
  return const SpinKitWave(
    color: FinColor.mainColor,
    size: 20.0,
  );
}