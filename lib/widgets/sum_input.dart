import 'package:flutter/material.dart';
import '../constants.dart';

class SumInput extends StatelessWidget {
  const SumInput({Key? key, required this.onSumChanged}) : super(key: key);

  final ValueChanged<double> onSumChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: FinFont.semibold.copyWith(fontSize: 32),
            textAlign: TextAlign.end,
            cursorColor: FinColor.darkBlue,
            keyboardType: TextInputType.number,
            onChanged: (s) {
              onSumChanged(double.parse(s.replaceAll(',', '.')));
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: FinFont.semibold.copyWith(
                color: FinColor.darkBlue.withAlpha(0x80),
              ),
              hintText: "0",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '₽',
            style: FinFont.semibold.copyWith(fontSize: 32),
          ),
        )
      ],
    );
  }
}
