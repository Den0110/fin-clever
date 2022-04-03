import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/utils/helper.dart';
import 'package:fin_clever/widgets/title_appbar.dart';
import 'package:fin_clever/widgets/select_account_type_dialog.dart';
import 'package:fin_clever/widgets/selectable.dart';
import 'package:fin_clever/widgets/sum_input.dart';
import 'package:fin_clever/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/button.dart';

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
                        child: button(
                          text: 'Сохранить',
                          onPressed: () =>
                              {saveAccount(context.read<Account>())},
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
      showToast(context, 'Выберите название счета');
      return;
    }

    if (account.balance < 0) {
      showToast(context, 'Некорректная начальная сумма');
      return;
    }

    final res = await _accountService.createAccount(account);
    showToast(context, res ? 'Счет создан' : 'Неизвестная ошибка');
    if (res) {
      Navigator.maybePop(context, true);
    }
  }
}
