import 'package:fin_clever/ext.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/accounts.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/services/operation_service.dart';
import 'package:fin_clever/widgets/appbar.dart';
import 'package:fin_clever/widgets/operation_category_selector.dart';
import 'package:fin_clever/widgets/select_account_dialog.dart';
import 'package:fin_clever/widgets/select_date_dialog.dart';
import 'package:fin_clever/widgets/selectable.dart';
import 'package:fin_clever/widgets/sum_input.dart';
import 'package:fin_clever/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({Key? key}) : super(key: key);

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _operationService = OperationService();
  final _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _accountService.loadAccounts().then((value) {
      context.read<Accounts>().updateAccounts(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final realAccounts = context.watch<Accounts>().accounts;

    return ChangeNotifierProvider(create: (BuildContext context) {
      return Operation.create(OperationType.income);
    }, builder: (context, w) {
      return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const TitleAppBar(title: 'Добавить доход'),
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
                      SumInput(onSumChanged: (v) {
                        context.read<Operation>().value = v;
                      }),
                      OperationCategorySelector(
                        categories: incomeCategories,
                      ),
                      Selectable(
                          icon: FinCleverIcons.ic_wallet,
                          text: _getAccountName(
                            context,
                            realAccounts,
                          ),
                          onTap: () {
                            showSelectAccountDialog(
                              context,
                              realAccounts,
                            );
                          }),
                      Selectable(
                        icon: FinCleverIcons.ic_date,
                        text: context.watch<Operation>().date.formatDate(),
                        onTap: () async {
                          showSelectDateDialog(context);
                        },
                      ),
                      TextInput(
                        icon: FinCleverIcons.ic_comment,
                        hint: 'Комментрарий',
                        onChanged: (s) {
                          context.read<Operation>().note = s;
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
                              {saveOperation(context.read<Operation>())},
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

  _getAccountName(BuildContext context, List<Account> realAccounts) {
    final operation = context.read<Operation>();
    if (operation.accountId == -1) {
      if (realAccounts.isNotEmpty) {
        operation.accountId = realAccounts[0].id;
        return realAccounts[0].name;
      } else {
        operation.accountId = -1;
        return 'Счет списания';
      }
    } else {
      return realAccounts.firstWhere((e) => e.id == operation.accountId).name;
    }
  }

  void saveOperation(Operation operation) async {
    if (operation.value == 0) {
      _showToast('Введите сумму');
      return;
    }

    if (operation.category.isEmpty) {
      _showToast('Выберите категорию');
      return;
    }

    if (operation.accountId == -1) {
      _showToast('Выберите счет зачисления');
      return;
    }

    final res = await _operationService.createOperation(operation);
    _showToast(res ? 'Доход сохранен' : 'Неизвестная ошибка');
  }

  _showToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
