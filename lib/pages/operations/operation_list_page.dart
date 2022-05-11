import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/models/provider/day_entries.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../../fin_clever_icons_icons.dart';
import '../../models/potential_profit_request.dart';
import '../../models/provider/current_user.dart';
import '../../services/portfolio_service.dart';
import '../../utils/constants.dart';
import '../../models/provider/accounts.dart';
import '../../models/provider/operations.dart';
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
  final PortfolioService _portfolioService = PortfolioService();
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

  static final recommendations = [
    'Не потратив так много на {cat}, вы могли бы заработать {investSum}, инвестируя в растущие компании',
    'Вы упустили доход {investSum}, потратя деньги на {cat}',
    'Могли вложить {sum} в акции и заработать {investSum}',
    'Фондовый рынок мог бы превратить Ваши {sum} в {investSum}'
  ];

  Future<void> _loadData() {
    return Future.wait([
      _accountService
          .loadAccounts()
          .then((v) => {context.read<Accounts>().updateAccounts(v)}),
      _operationService.loadOperations().then((operations) async {
        context.read<Operations>().updateOperations(operations);
        final List<DayEntry> days = [];
        groupBy(operations.sortedBy((Operation o) => o.date).reversed,
            (Operation o) {
          return DateFormat('yyyyMMdd').format(o.date);
        }).forEach((key, value) {
          days.add(DayEntry(DateTime.parse(key), value));
        });
        var lastMonth = "";
        for (var i = 0; i < days.length; i++) {
          var month = DateFormat('MMyyyy').format(days[i].date);
          if (month != lastMonth) {
            days[i].isFirstDayOfMonth = true;
            days[i].recommendation = await _buildRecommendation(days[i]);
            lastMonth = month;
          }
        }
        context.read<DayEntries>().updateDayEntries(days);
      })
    ]).then((value) => hideLoading());
  }

  Future<String?> _buildRecommendation(DayEntry day) async {
    if (!day.isFirstDayOfMonth) return null;

    var user = context.read<CurrentUser>().user;
    final operations = context.read<Operations>().operations;
    var junkCats = user?.junkCategories?.split(',');
    var junkLimit = user?.junkLimit;

    if (junkCats == null ||
        junkCats.isEmpty ||
        junkLimit == null ||
        junkLimit == 0) {
      return null;
    }

    var junkExpenses = operations.where((e) =>
        e.type == OperationType.expense &&
        e.date.formatMY() == day.date.formatMY() &&
        junkCats.contains(e.category));

    if (junkExpenses.isEmpty) return null;

    var sum = junkExpenses.map((e) => e.value).reduce((a, b) => a + b);
    if (sum < junkLimit) return null;
    var investSum = .0;

    try {
      investSum = await _portfolioService
          .getPotentialProfit(PotentialProfitRequest(day.date, sum));
    } catch (e) {
      return null;
    }

    var cats = junkCats
        .map((e) => expenseCategories
            .firstWhere((c) => c.key == e,
                orElse: () => OperationCategory("", "", FinCleverIcons.ic_name))
            .name)
        .where((e) => e.isNotEmpty);

    return recommendations[
            Random(day.operations.length).nextInt(recommendations.length)]
        .replaceFirst('{sum}', sum.formatMoney())
        .replaceFirst('{investSum}', investSum.formatMoney())
        .replaceFirst('{cat}', cats.join(', ').toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    var dayEntries = context.read<DayEntries>().dayEntries;
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
                  itemCount: dayEntries.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return summary();
                    } else {
                      return DayOfOperationsItem(
                        dayEntry: dayEntries[index - 1],
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
        .where((o) => o.date.formatMY() == DateTime.now().formatMY())
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
