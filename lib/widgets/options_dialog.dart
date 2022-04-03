import 'package:ej_selector/ej_selector.dart';
import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

Future<int?> showOptionsDialog(BuildContext context, List<String> options) async {
  final selectedItem = await showEJDialog<int>(
    context: context,
    selected: null,
    items: options.map((e) => EJSelectorItem(
      value: options.indexOf(e),
      widget: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Text(
          e,
          style: FinFont.medium
              .copyWith(fontSize: 16, color: FinColor.mainColor),
        ),
      ),
    )).toList(),
  );
  return selectedItem?.value;
}