import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fin_clever/data/models/account.dart';
import 'package:fin_clever/data/services/account_service.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:fin_clever/widgets/cat_of_accounts_item.dart';
import 'package:fin_clever/widgets/title_appbar.dart';
import 'package:fin_clever/widgets/user_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../data/models/provider/accounts.dart';
import '../../utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../widgets/loading.dart';
import 'add_account.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({Key? key}) : super(key: key);

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  bool isAutoLoading = false;
  final AccountService _accountService = AccountService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    if (context.read<Accounts>().accounts.isEmpty) {
      showLoading();
      _loadData();
    }
  }

  void navigateToAddAccount() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddAccountPage()))
        .then((value) {
      if (value) {
        _loadData();
        showLoading();
      }
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
    return _accountService.loadAccounts().then((accounts) {
      context.read<Accounts>().updateAccounts(accounts);
      hideLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            const TitleAppBar(title: 'Мои счета'),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                displacement: 20,
                onRefresh: _loadData,
                child: _content(),
              ),
            )
          ]),
          if (isAutoLoading) ...[loading()]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddAccount,
        tooltip: 'Добавить счет',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _content() {
    final cats = [];
    final accounts = context.watch<Accounts>().accounts;
    groupBy(accounts, (Account o) {
      return o.type.namePlural;
    }).forEach((key, value) {
      cats.add(CatEntry(key, value));
    });
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        FinDimen.horizontal,
        16,
        FinDimen.horizontal,
        86,
      ),
      itemCount: cats.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return summary();
        } else {
          return CatOfAccountsItem(dayEntry: cats[index - 1]);
        }
      },
    );
  }

  Widget summary() {
    final accounts = context.watch<Accounts>().accounts;
    final onAll = accounts
        .where((e) => e.type != AccountType.credit)
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
                const Text('На всех счетах'),
                Text(
                  onAll.formatMoney(),
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
