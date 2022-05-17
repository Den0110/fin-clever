import 'package:fin_clever/bloc/day_entry.dart';
import 'package:fin_clever/bloc/operation_list_bloc.dart';
import 'package:fin_clever/bloc/operation_list_event.dart';
import 'package:fin_clever/bloc/operation_list_state.dart';
import 'package:fin_clever/data/models/provider/current_user.dart';
import 'package:fin_clever/data/services/account_service.dart';
import 'package:fin_clever/data/services/operation_service.dart';
import 'package:fin_clever/data/services/portfolio_service.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:fin_clever/widgets/day_of_operations_item.dart';
import 'package:fin_clever/widgets/user_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../utils/constants.dart';
import '../../widgets/loading.dart';
import 'add_expense.dart';
import 'add_income.dart';

class OperationListPage extends StatefulWidget {
  const OperationListPage({Key? key}) : super(key: key);

  @override
  State<OperationListPage> createState() => _OperationListPageState();
}

class _OperationListPageState extends State<OperationListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OperationListBloc(
        context.read<CurrentUser>().user,
        // todo: передавать singleton'ы используя di
        OperationService(),
        AccountService(),
        PortfolioService(),
      )..add(OperationListDataLoadRequested()),
      child: BlocConsumer<OperationListBloc, OperationListState>(
        listener: (context, state) {
          if (state is OperationListNavToAddExpense) {
            _navigateToAddExpense(context);
          } else if (state is OperationListNavToAddIncome) {
            _navigateToAddIncome(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: userAppBar(context),
            body: const OperationListBody(),
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
                    onTap: () =>
                        context
                            .read<OperationListBloc>()
                            .add(OperationListAddExpensePressed()),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.add),
                    label: 'Доход',
                    labelBackgroundColor: Colors.white,
                    backgroundColor: FinColor.mainColor,
                    onTap: () =>
                        context
                            .read<OperationListBloc>()
                            .add(OperationListAddIncomePressed()),
                  ),
                ]),
          );
        },
      ),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddExpensePage()))
        .then((value) => context
            .read<OperationListBloc>()
            .add(OperationListDataLoadRequested()));
  }

  void _navigateToAddIncome(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddIncomePage()))
        .then((value) => context
            .read<OperationListBloc>()
            .add(OperationListDataLoadRequested()));
  }
}

class OperationListBody extends StatelessWidget {
  const OperationListBody({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 20,
      onRefresh: () async {
        context.read<OperationListBloc>().add(OperationListDataLoadRequested());
      },
      child: BlocBuilder<OperationListBloc, OperationListState>(
        builder: (context, state) {
          if (state is OperationListLoadInProgress) {
            return loading();
          } else if (state is OperationListLoadSuccess) {
            return OperationListContent(
              dayEntries: state.dayEntries,
              withMe: state.withMe,
              thisMonth: state.thisMonth,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class OperationListContent extends StatelessWidget {
  final List<DayEntry> dayEntries;
  final double withMe;
  final int thisMonth;

  const OperationListContent(
      {Key? key,
      required this.dayEntries,
      required this.withMe,
      required this.thisMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                return OperationListSummary(
                  withMe: withMe,
                  thisMonth: thisMonth,
                );
              } else {
                return DayOfOperationsItem(
                  dayEntry: dayEntries[index - 1],
                  onDelete: (operationId) => context
                      .read<OperationListBloc>()
                      .add(OperationListDeleteItemPressed(operationId)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class OperationListSummary extends StatelessWidget {
  final double withMe;
  final int thisMonth;

  const OperationListSummary(
      {Key? key, required this.withMe, required this.thisMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
