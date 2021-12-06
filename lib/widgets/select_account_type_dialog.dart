import 'package:ej_selector/ej_selector.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';

Future<void> showSelectAccountTypeDialog(
  BuildContext context,
  List<AccountType> types,
) async {
  final selectedItem = await showEJDialog<int>(
    context: context,
    selected: types.indexOf(context.read<Account>().type),
    selectedWidgetBuilder: (selectedId) => Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        types[selectedId].nameSingle,
        style: FinFont.medium.copyWith(fontSize: 20, color: FinColor.mainColor),
      ),
    ),
    items: types
        .map(
          (item) => EJSelectorItem(
            value: item.index,
            widget: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Text(
                item.nameSingle,
                style: FinFont.medium
                    .copyWith(fontSize: 16, color: FinColor.secondaryText),
              ),
            ),
          ),
        )
        .toList(),
  );
  if (selectedItem != null) {
    context.read<Account>().selectAccountType(types[selectedItem.value]);
  }
}
