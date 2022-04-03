import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/widgets/title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/constants.dart';
import '../../models/invest/invest_operation.dart';
import '../../services/portfolio_service.dart';
import '../../widgets/invest_operation_item.dart';
import '../../widgets/loading.dart';

class InvestOperationsPage extends StatefulWidget {
  const InvestOperationsPage({Key? key}) : super(key: key);

  @override
  State<InvestOperationsPage> createState() => _InvestOperationsPageState();
}

class _InvestOperationsPageState extends State<InvestOperationsPage> {
  final PortfolioService _portfolioService = PortfolioService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isAutoLoading = false;
  final List<InvestDayEntry> _days = [];
  bool isChanged = false;

  @override
  initState() {
    super.initState();
    showLoading();
    _loadData();
  }

  Future<void> _loadData() {
    return _portfolioService.loadInvestOperations().then((operations) => {
          setState(() {
            _days.clear();
            groupBy(operations.sortedBy((InvestOperation o) => o.date).reversed,
                (InvestOperation o) {
              return o.date.formatDate();
            }).forEach((key, value) {
              _days.add(InvestDayEntry(key, value));
            });
            hideLoading();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TitleAppBar(
                title: 'История операций',
                getResult: () => isChanged,
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  displacement: 20,
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      FinDimen.horizontal,
                      16,
                      FinDimen.horizontal,
                      16,
                    ),
                    itemCount: _days.length,
                    itemBuilder: (context, index) {
                      return InvestOperationItem(
                        dayEntry: _days[index],
                        onDelete: (operationId) async {
                          final isDeleted = await _portfolioService
                              .deleteOperation(operationId);
                          if (isDeleted) {
                            isChanged = true;
                            _loadData();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (isAutoLoading) ...[loading()]
        ],
      ),
    );
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
}
