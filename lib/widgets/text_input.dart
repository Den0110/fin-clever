import 'package:flutter/material.dart';

import '../constants.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.onChanged})
      : super(key: key);

  final IconData icon;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.only(left: 10, top: 0),
              child: TextField(
                maxLines: null,
                style: FinFont.regular.copyWith(fontSize: 18),
                textAlign: TextAlign.start,
                cursorColor: FinColor.darkBlue,
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: FinFont.regular.copyWith(
                    color: FinColor.secondaryText,
                  ),
                  hintText: hint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
