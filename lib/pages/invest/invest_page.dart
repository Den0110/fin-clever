import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/invest/history_item.dart';
import '../../models/provider/portfolio_info.dart';
import '../../services/portfolio_service.dart';
import '../../utils/constants.dart';
import '../../widgets/caption.dart';
import '../../widgets/loading.dart';
import '../../widgets/stock_item.dart';
import 'add_invest_operation.dart';
import 'invest_operations_page.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({Key? key}) : super(key: key);

  @override
  _InvestPageState createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  final PortfolioService _portfolioService = PortfolioService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isAutoLoading = false;
  bool showContent = false;
  bool showChart = false;

  @override
  initState() {
    super.initState();
    if (context.read<PortfolioInfo>().portfolio == null) {
      showLoading();
      _loadData();
    } else {
      showContent = true;
      showChart = true;
      hideLoading();
    }
  }

  Future<void> _loadData() {
    final range = context.read<PortfolioInfo>().range;
    final showHistoricalProfit =
        context.read<PortfolioInfo>().showHistoricalProfit;
    return _portfolioService
        .loadPortfolio(range, showHistoricalProfit)
        .then((p) => {
              setState(() {
                context.read<PortfolioInfo>().updatePortfolio(p);
                showContent = true;
                showChart = true;
                hideLoading();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            _buildPortfolioAppBar(),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                displacement: 20,
                onRefresh: _loadData,
                child: showContent ? _content() : Column(),
              ),
            )
          ],
        ),
        if (isAutoLoading) ...[loading()]
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddOperation,
        tooltip: 'Добавить операцию',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _content() {
    final stocks = context.watch<PortfolioInfo>().portfolio?.stocks ?? [];
    const extraWidgetNum = 3;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 86),
      itemCount: stocks.length + extraWidgetNum,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              caption('История портфеля'),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  " обновляется каждые 5-10 минут",
                  style: FinFont.regular.copyWith(fontSize: 10),
                ),
              )
            ],
          );
        } else if (index == 1) {
          return _buildChart();
        } else if (index == 2) {
          return caption('Акции');
        } else {
          return StockItem(stock: stocks[index - extraWidgetNum]);
        }
      },
    );
  }

  Widget _buildPortfolioAppBar() {
    final totalPrice =
        context.watch<PortfolioInfo>().portfolio?.totalPrice ?? .0;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(0),
      child: Container(
        height: FinDimen.statusBarHeight + 56,
        decoration: const BoxDecoration(
          gradient: FinColor.mainGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            FinDimen.horizontal,
            FinDimen.vertical + FinDimen.statusBarHeight,
            8,
            FinDimen.vertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мой портфель',
                    style: FinFont.extraBold.copyWith(fontSize: 16),
                  ),
                  Text(
                    totalPrice.formatMoney(currency: "\$"),
                    style: FinFont.regular.copyWith(fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(FinCleverIcons.ic_history_of_operations),
                onPressed: () {
                  _navigateToOperations();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOperations() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => const InvestOperationsPage()))
        .then((isChanged) {
      if (isChanged) {
        showLoading();
        _loadData();
      }
    });
  }

  void _navigateToAddOperation() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => const AddInvestOperationPage()))
        .then((isChanged) {
      if (isChanged) {
        showLoading();
        _loadData();
      }
    });
  }

  Widget _buildChart() {
    return Column(children: [
      SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: showChart ? _buildCartesianChart() : loading(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: FinDimen.horizontal,
          right: FinDimen.horizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeRangeItem("Н", "W"),
            _buildTimeRangeItem("М", "M"),
            _buildTimeRangeItem("6М", "6M"),
            _buildTimeRangeItem("1Г", "1Y"),
            _buildTimeRangeItem("ВСЕ", "ALL"),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(
            left: FinDimen.horizontal,
            top: 12,
            right: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Показать историческую доходность',
                        style: FinFont.medium),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                          'Как менялась цена Вашего портфеля с текущим набором акций со временем',
                          style: FinFont.regular.copyWith(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Column(children: [
                Switch(
                  value: context.watch<PortfolioInfo>().showHistoricalProfit,
                  onChanged: (bool value) {
                    setState(() {
                      showChart = false;
                    });
                    context
                        .read<PortfolioInfo>()
                        .updateShowHistoricalProfit(value);
                    _loadData();
                  },
                )
              ]),
            ],
          )),
    ]);
  }

  Widget _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: false),
      primaryXAxis: CategoryAxis(
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(_formatDate(details.text), null);
        },
        majorGridLines: const MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '\${value}',
        majorTickLines: const MajorTickLines(size: 0),
      ),
      enableAxisAnimation: true,
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
      ),
      series: _getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: false),
    );
  }

  String _formatDate(String unix) {
    final range = context.watch<PortfolioInfo>().range;
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(unix));
    if (range == "W" || range == "M") {
      return date.formatDM();
    }
    return date.formatMY();
  }

  Widget _buildTimeRangeItem(String t, String rangeValue) {
    final range = context.watch<PortfolioInfo>().range;
    Color? bgColor;
    Color textColor;
    if (range == rangeValue) {
      bgColor = FinColor.mainColor.withAlpha(180);
      textColor = Colors.white;
    } else {
      bgColor = null;
      textColor = FinColor.darkBlue;
    }
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: bgColor),
      child: Text(
        t,
        style: FinFont.semibold.copyWith(color: textColor, fontSize: 12),
      ),
      onPressed: () {
        setState(() {
          context.read<PortfolioInfo>().updateRange(rangeValue);
          showChart = false;
        });
        _loadData();
      },
    );
  }

  List<SplineSeries<HistoryItem, String>> _getDefaultSplineSeries() {
    final history =
        context.watch<PortfolioInfo>().portfolio?.priceHistory ?? [];
    return <SplineSeries<HistoryItem, String>>[
      SplineSeries<HistoryItem, String>(
        dataSource: history,
        xValueMapper: (HistoryItem price, _) =>
            (price.date.millisecondsSinceEpoch).toString(),
        yValueMapper: (HistoryItem price, _) => price.price,
        markerSettings: const MarkerSettings(isVisible: false),
        color: FinColor.mainColor,
      ),
    ];
  }

  void showLoading() {
    setState(() {
      showContent = false;
    });
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
