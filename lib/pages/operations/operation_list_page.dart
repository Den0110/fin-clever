import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/services/operation_service.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:fin_clever/widgets/day_of_operations_item.dart';
import 'package:fin_clever/widgets/user_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/src/provider.dart';
import '../../utils/constants.dart';
import '../../models/provider/accounts.dart';
import '../../models/provider/operations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../widgets/loading.dart';
import 'add_expense.dart';
import 'add_income.dart';

class OperationListPage extends StatefulWidget {
  const OperationListPage({Key? key}) : super(key: key);

  @override
  State<OperationListPage> createState() => _OperationListPageState();
}

class _OperationListPageState extends State<OperationListPage> {
  bool isAutoLoading = false;
  final OperationService _operationService = OperationService();
  final AccountService _accountService = AccountService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    if (context.read<Operations>().operations.isEmpty) {
      showLoading();
      _loadData();
    }
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
    return Future.wait([
      _accountService
          .loadAccounts()
          .then((v) => {context.read<Accounts>().updateAccounts(v)}),
      _operationService.loadOperations().then((operations) =>
          {context.read<Operations>().updateOperations(operations)})
    ]).then((value) => hideLoading());
  }

  @override
  Widget build(BuildContext context) {
    final days = [];
    final operations = context.watch<Operations>().operations;
    groupBy(operations.sortedBy((Operation o) => o.date).reversed,
        (Operation o) {
      return o.date.formatDate();
    }).forEach((key, value) {
      days.add(DayEntry(key, value));
    });
    return Scaffold(
      appBar: userAppBar(context),
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
                    86,
                  ),
                  itemCount: days.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return summary();
                    } else {
                      return DayOfOperationsItem(
                        dayEntry: days[index - 1],
                        onDelete: (operationId) async {
                          final isDeleted = await _operationService
                              .deleteOperation(operationId);
                          if (isDeleted) {
                            _loadData();
                            showLoading();
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (isAutoLoading) ...[loading()]
      ]),
      floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: FinColor.mainColor,
          overlayOpacity: 0,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.remove),
              label: 'Расход',
              labelBackgroundColor: Colors.white,
              backgroundColor: FinColor.mainColor,
              onTap: () {
                navigateToAddExpense();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Доход',
              labelBackgroundColor: Colors.white,
              backgroundColor: FinColor.mainColor,
              onTap: () {
                navigateToAddIncome();
              },
            ),
          ]),
    );
  }

  Widget summary() {
    final operations = context.watch<Operations>().operations;
    final accounts = context.watch<Accounts>().accounts;
    final withMe = accounts
        .where((e) =>
            e.type == AccountType.debitCard || e.type == AccountType.cash)
        .map((e) => e.balance)
        .sum;
    final thisMonth = operations
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
                  withMe.formatMoney(),
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
                  thisMonth.formatMoney(),
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
