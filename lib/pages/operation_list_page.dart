import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/ext.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/accounts.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/services/operation_service.dart';
import 'package:fin_clever/widgets/day_of_operations_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import '../pages/add_expense.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'add_income.dart';

class OperationListPage extends StatefulWidget {
  const OperationListPage({Key? key}) : super(key: key);

  @override
  State<OperationListPage> createState() => _OperationListPageState();
}

class _OperationListPageState extends State<OperationListPage> {
  final List<DayEntry> _days = [];
  int thisMonth = 0;
  bool isAutoLoading = false;
  final OperationService _operationService = OperationService();
  final AccountService _accountService = AccountService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    showLoading();
    _loadData();
  }

  void navigateToAddExpense() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddExpensePage()))
        .then((value) {
      _loadData();
      showLoading();
    });
  }
  void navigateToAddIncome() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddIncomePage()))
        .then((value) {
      _loadData();
      showLoading();
    });
  }

  void showLoading() {
    EasyDebounce.debounce(
      'loading-debouncer',
      const Duration(milliseconds: 300),
      () {
        setState(() {
          isAutoLoading = true;
        });
      },
    );
  }

  void hideLoading() {
    EasyDebounce.debounce(
      'loading-debouncer',
      const Duration(milliseconds: 100),
      () {
        setState(() {
          isAutoLoading = false;
        });
      },
    );
  }

  Future<void> _loadData() {
    _accountService
        .loadAccounts()
        .then((v) => {context.read<Accounts>().accounts = v});
    return _operationService.loadOperations().then((operations) => {
          setState(() {
            thisMonth = operations
                .where((o) => o.date.month == DateTime.now().month)
                .map((o) {
                  switch (o.type) {
                    case OperationType.expense:
                      return -o.value;
                    case OperationType.income:
                      return o.value;
                  }
                })
                .sum
                .toInt();
            _days.clear();
            groupBy(operations.sortedBy((Operation o) => o.date).reversed,
                (Operation o) {
              return o.date.formatDate();
            }).forEach((key, value) {
              _days.add(DayEntry(key, value));
            });
            hideLoading();
          })
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: mainScreenAppBar(),
        body: Stack(children: [
          RefreshIndicator(
            key: _refreshIndicatorKey,
            displacement: 20,
            onRefresh: _loadData,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      FinDimen.horizontal,
                      16,
                      FinDimen.horizontal,
                      16,
                    ),
                    shrinkWrap: true,
                    itemCount: _days.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return summary();
                      } else {
                        return DayOfOperationsItem(dayEntry: _days[index - 1]);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isAutoLoading) ...[
            const SpinKitWave(
              color: FinColor.mainColor,
              size: 20.0,
            )
          ]
        ]),
        floatingActionButton: SpeedDial(
            icon: Icons.add,
            backgroundColor: FinColor.mainColor,
            overlayOpacity: 0,
            children: [
              SpeedDialChild(
                child: Icon(Icons.remove),
                label: 'Расход',
                labelBackgroundColor: Colors.white,
                backgroundColor: FinColor.mainColor,
                onTap: () {
                  navigateToAddExpense();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.add),
                label: 'Доход',
                labelBackgroundColor: Colors.white,
                backgroundColor: FinColor.mainColor,
                onTap: () {
                  navigateToAddIncome();
                },
              ),
            ]),
      );

  AppBar mainScreenAppBar() {
    return AppBar(
      toolbarHeight: 68,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: FinColor.mainGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            FinDimen.horizontal,
            FinDimen.vertical + FinDimen.statusBarHeight,
            FinDimen.horizontal,
            FinDimen.vertical,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage:
                    NetworkImage('https://picsum.photos/250?image=1'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: FinDimen.horizontal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          'Добрый день,',
                          style: FinFont.regular.copyWith(fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Username',
                          style: FinFont.extraBold.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summary() {
    final moneyFormat = NumberFormat("#,##0₽", "en_US");
    final accounts = context.watch<Accounts>().accounts;
    final withMe = accounts
        .where((e) =>
            e.type == AccountType.debitCard || e.type == AccountType.cash)
        .map((e) => e.balance)
        .sum;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('С собой'),
                Text(
                  moneyFormat.format(withMe),
                  style: FinFont.semibold.copyWith(fontSize: 32),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
                  Text('Этот '),
                  Text(
                    'месяц',
                    style: FinFont.semibold,
                  )
                ]),
                Text(
                  moneyFormat.format(thisMonth),
                  style: FinFont.regular.copyWith(
                    fontSize: 32,
                    color: thisMonth < 0 ? FinColor.red : FinColor.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
