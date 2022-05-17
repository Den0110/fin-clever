import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fin_clever/bloc/day_entry.dart';
import 'package:fin_clever/bloc/operation_list_state.dart';
import 'package:fin_clever/data/models/account.dart';
import 'package:fin_clever/data/models/app_user.dart';
import 'package:fin_clever/data/models/operation.dart';
import 'package:fin_clever/data/models/potential_profit_request.dart';
import 'package:fin_clever/data/services/account_service.dart';
import 'package:fin_clever/data/services/operation_service.dart';
import 'package:fin_clever/data/services/portfolio_service.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'operation_list_event.dart';

class OperationListBloc extends Bloc<OperationListEvent, OperationListState> {
  static final recommendations = [
    'Не потратив так много на {cat}, вы могли бы заработать {investSum}, инвестируя в растущие компании',
    'Вы упустили доход {investSum}, потратя деньги на {cat}',
    'Могли вложить {sum} в акции и заработать {investSum}',
    'Фондовый рынок мог бы превратить Ваши {sum} в {investSum}'
  ];

  final AppUser? _user;
  final OperationService _operationService;
  final AccountService _accountService;
  final PortfolioService _portfolioService;

  OperationListBloc(
    this._user,
    this._operationService,
    this._accountService,
    this._portfolioService,
  ) : super(OperationListInitial()) {
    on<OperationListDataLoadRequested>((event, emit) async {
      await _loadData(emit);
    });
    on<OperationListAddExpensePressed>((event, emit) async {
      emit(OperationListNavToAddExpense());
    });
    on<OperationListAddIncomePressed>((event, emit) async {
      emit(OperationListNavToAddIncome());
    });
    on<OperationListDeleteItemPressed>((event, emit) async {
      if (await _operationService.deleteOperation(event.operationId)) {
        await _loadData(emit);
      }
    });
  }

  Future<void> _loadData(Emitter<OperationListState> emit) async {
    try {
      emit(OperationListLoadInProgress());
      final operations = await _operationService.loadOperations();
      final accounts = await _accountService.loadAccounts();
      emit(OperationListLoadSuccess(
        dayEntries: await _convertToDayEntries(_user, operations),
        withMe: _calcWithMe(operations, accounts),
        thisMonth: _calcThisMonth(operations, accounts),
      ));
    } on Exception catch (error) {
      emit(OperationListLoadError(error));
    }
  }

  Future<List<DayEntry>> _convertToDayEntries(
    AppUser? user,
    List<Operation> operations,
  ) async {
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
        days[i].recommendation =
            await _buildRecommendation(user, operations, days[i]);
        lastMonth = month;
      }
    }
    return days;
  }

  Future<String?> _buildRecommendation(
      AppUser? user, List<Operation> operations, DayEntry day) async {
    if (!day.isFirstDayOfMonth) return null;

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

    var randomRec = recommendations[
        Random(day.operations.length).nextInt(recommendations.length)];

    return randomRec
        .replaceFirst('{sum}', sum.formatMoney())
        .replaceFirst('{investSum}', investSum.formatMoney())
        .replaceFirst('{cat}', cats.join(', ').toLowerCase());
  }

  double _calcWithMe(List<Operation> operations, List<Account> accounts) {
    return accounts
        .where((e) =>
            e.type == AccountType.debitCard || e.type == AccountType.cash)
        .map((e) => e.balance)
        .sum;
  }

  int _calcThisMonth(List<Operation> operations, List<Account> accounts) {
    return operations
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
  }
}
