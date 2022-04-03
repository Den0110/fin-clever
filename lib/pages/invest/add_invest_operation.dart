import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/utils/date.dart';
import 'package:fin_clever/widgets/text_input.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../fin_clever_icons_icons.dart';
import '../../models/invest/invest_operation.dart';
import '../../services/portfolio_service.dart';
import '../../utils/formatters.dart';
import '../../utils/helper.dart';
import '../../widgets/button.dart';
import '../../widgets/loading.dart';
import '../../widgets/selectable.dart';
import '../../widgets/title_appbar.dart';

class AddInvestOperationPage extends StatefulWidget {
  const AddInvestOperationPage({Key? key}) : super(key: key);

  @override
  State<AddInvestOperationPage> createState() => _AddInvestOperationPageState();
}

class _AddInvestOperationPageState extends State<AddInvestOperationPage> {
  bool isAutoLoading = false;
  final PortfolioService _portfolioService = PortfolioService();
  String ticker = "";
  DateTime date = DateTime.now();
  double price = .0;
  int amount = 0;

  void _submit(bool isBuy) async {
    if (ticker.trim().isEmpty) {
      showToast(context, 'Введите тикер (к примеру: AAPL)');
      return;
    }

    if (price == 0) {
      showToast(context, 'Введите цену');
      return;
    }

    if (price < 0) {
      showToast(context, 'Введите неотрицательную цену');
      return;
    }

    if (amount == 0) {
      showToast(context, 'Введите количество');
      return;
    }

    if (amount < 0) {
      showToast(context, 'Введите неотрицательное количество');
      return;
    }

    final operation = InvestOperation(
      0,
      date,
      ticker,
      price,
      amount * (isBuy ? 1 : -1),
    );

    final res = await _portfolioService.addOperation(operation);
    showToast(
        context,
        res
            ? 'Операция сохранена'
            : 'Ошибка, проверьте корректность введенного тикера');

    if (res) {
      Navigator.maybePop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const TitleAppBar(title: 'Добавить операцию'),
        Expanded(child: !isAutoLoading ? _content() : loading()),
      ]),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: FinDimen.horizontal,
          top: FinDimen.horizontal,
          right: FinDimen.horizontal,
          bottom: FinDimen.horizontal,
        ),
        child: Column(
          children: <Widget>[
            _tickerInput(),
            Selectable(
              icon: FinCleverIcons.ic_date,
              text: date.formatDate(),
              onTap: () async {
                var d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime.now(),
                );
                if (d != null) {
                  setState(() {
                    date = d;
                  });
                }
              },
            ),
            TextInput(
              icon: FinCleverIcons.ic_price_of_stock,
              keyboardType: TextInputType.number,
              hint: 'Цена акции',
              onChanged: (s) {
                setState(() {
                  price = double.tryParse(s.replaceAll(',', '.')) ?? .0;
                });
              },
            ),
            TextInput(
              icon: FinCleverIcons.ic_amount_of_stocks,
              keyboardType: TextInputType.number,
              hint: 'Количество акций',
              onChanged: (s) {
                setState(() {
                  amount = int.tryParse(s) ?? 0;
                });
              },
            ),
            _buySellButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buySellButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: button(
                text: 'Купить',
                onPressed: () => {_submit(true)},
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: button(
                text: 'Продать',
                onPressed: () => {_submit(false)},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tickerInput() {
    return Row(children: [
      Expanded(
        child: TextFormField(
          style: FinFont.semibold.copyWith(fontSize: 32),
          textAlign: TextAlign.start,
          cursorColor: FinColor.darkBlue,
          onChanged: (s) {
            setState(() {
              ticker = s;
            });
          },
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: FinFont.semibold.copyWith(
              color: FinColor.darkBlue.withAlpha(0x80),
            ),
            hintText: "Тикер акции",
          ),
        ),
      ),
    ]);
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
