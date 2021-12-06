import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/widgets/appbar.dart';
import 'package:fin_clever/widgets/select_account_type_dialog.dart';
import 'package:fin_clever/widgets/selectable.dart';
import 'package:fin_clever/widgets/sum_input.dart';
import 'package:fin_clever/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({Key? key}) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return Account.create();
    }, builder: (context, w) {
      return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const TitleAppBar(title: 'Добавить счет'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: FinDimen.horizontal,
                    top: FinDimen.horizontal,
                    right: FinDimen.horizontal,
                    bottom: FinDimen.buttonPadding,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextInput(
                        icon: FinCleverIcons.ic_wallet,
                        hint: 'Название счета',
                        onChanged: (s) {
                          context.read<Account>().name = s;
                        },
                      ),
                      Selectable(
                        icon: FinCleverIcons.ic_account_category,
                        text: context.watch<Account>().type.nameSingle,
                        onTap: () {
                          showSelectAccountTypeDialog(
                            context,
                            AccountType.values,
                          );
                        },
                      ),
                      TextInput(
                        icon: FinCleverIcons.ic_initial_amount,
                        hint: 'Начальная сумма',
                        onChanged: (s) {
                          context.read<Account>().balance =
                              double.parse(s.replaceAll(',', '.'));
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Сохранить',
                            style: FinFont.semibold
                                .copyWith(fontSize: 14, color: Colors.white),
                          ),
                          onPressed: () =>
                              {saveAccount(context.read<Account>())},
                          style: ElevatedButton.styleFrom(
                            primary: FinColor.mainColor,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void saveAccount(Account account) async {
    if (account.name.isEmpty) {
      _showToast('Выберите название счета');
      return;
    }

    final res = await _accountService.createAccount(account);
    _showToast(res ? 'Счет создан' : 'Неизвестная ошибка');
  }

  _showToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
