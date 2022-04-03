import 'package:fin_clever/utils/constants.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:flutter/material.dart';
import 'accounts/account_list_page.dart';
import 'invest/invest_page.dart';
import 'operations/operation_list_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _pageIndex = 0;

  static const pages = <Widget>[
    OperationListPage(),
    AccountListPage(),
    InvestPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onPageSelected,
        currentIndex: _pageIndex,
        selectedItemColor: FinColor.mainColor,
        unselectedItemColor: FinColor.secondaryText,
        items: const [
          BottomNavigationBarItem(icon: Icon(FinCleverIcons.ic_home_page, size: 18,), label: "Главная"),
          BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(right: 5.5), child: Icon(FinCleverIcons.ic_bank_card, size: 14),), label: "Счета"),
          BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(right: 5.5), child: Icon(FinCleverIcons.ic_investment, size: 14),), label: "Инвестиции"),
          BottomNavigationBarItem(
              icon: Icon(FinCleverIcons.ic_profile, size: 18,), label: "Профиль")
        ],
      ),
    );
  }

  void _onPageSelected(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

}