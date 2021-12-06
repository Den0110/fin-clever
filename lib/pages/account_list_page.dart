import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/ext.dart';
import 'package:fin_clever/models/account.dart';
import 'package:fin_clever/models/accounts.dart';
import 'package:fin_clever/services/account_service.dart';
import 'package:fin_clever/widgets/cat_of_accounts_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import '../pages/add_expense.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'add_account.dart';
import 'add_income.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({Key? key}) : super(key: key);

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final List<CatEntry> _cats = [];
  bool isAutoLoading = false;
  final AccountService _accountService = AccountService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    showLoading();
    _loadData();
  }

  void navigateToAddAccount() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddAccountPage()))
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
    return _accountService.loadAccounts().then((accounts) => {
          setState(() {
            context.read<Accounts>().updateAccounts(accounts);
            _cats.clear();
            groupBy(accounts, (Account o) {
              return o.type.namePlural;
            }).forEach((key, value) {
              _cats.add(CatEntry(key, value));
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
                    itemCount: _cats.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return summary();
                      } else {
                        return CatOfAccountsItem(dayEntry: _cats[index - 1]);
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
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddAccount,
          tooltip: 'Add account',
          child: const Icon(Icons.add, color: Colors.white,),
        ),
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
    final onAll = accounts.map((e) => e.balance).sum;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('На всех счетах'),
                Text(
                  moneyFormat.format(onAll),
                  style: FinFont.semibold.copyWith(fontSize: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
