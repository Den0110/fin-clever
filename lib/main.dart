import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinClever',
      theme: ThemeData(
          primarySwatch: FinColor.mainColor,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Montserrat',
                bodyColor: FinColor.darkBlue,
                displayColor: FinColor.darkBlue,
              )),
      home: const MyHomePage(title: 'FinClever'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainScreenAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            FinDimen.horizontal,
            16,
            FinDimen.horizontal,
            16,
          ),
          child: Column(
            children: <Widget>[
              summary(),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    day(),
                    day(),
                    day(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Analytics"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Profile")
        ],
      ),
    );
  }

  Card day() {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      shadowColor: const Color(0x33000000),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'сегодня, 16 ноября',
              style: FinFont.bold.copyWith(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  operation(),
                  divider,
                  operation(),
                  divider,
                  operation(),
                  divider,
                  operation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row operation() {
    var b = Random().nextBool();
    Color color;
    int value = 0;
    if (b) {
      value = -Random().nextInt(2000);
      color = FinColor.red;
    } else {
      value = Random().nextInt(2000);
      color = FinColor.green;
    }
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0x1A000000),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child:
              const Icon(Icons.eleven_mp, size: 24, color: FinColor.darkBlue),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dropbox Plan',
                  style: FinFont.medium.copyWith(fontSize: 14),
                ),
                Text('Подписки', style: FinFont.regular.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$value₽',
              style: FinFont.semibold.copyWith(
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              '${Random().nextInt(24)}:${Random().nextInt(49) + 10}',
              style: FinFont.regular.copyWith(fontSize: 12),
            ),
          ],
        )
      ],
    );
  }

  static const Divider divider = Divider(
    height: 24,
    thickness: .5,
    color: Color(0xFFEFEFEF),
  );

  Row summary() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('С собой'),
              Text(
                '8,420₽',
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
                '-2,420₽',
                style:
                    FinFont.regular.copyWith(fontSize: 32, color: FinColor.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar mainScreenAppBar() {
    return AppBar(
      toolbarHeight: 68,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: FinColor.mainGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: FinDimen.appBarBorderRadius,
            bottomRight: FinDimen.appBarBorderRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              FinDimen.horizontal,
              FinDimen.vertical + FinDimen.statusBarHeight,
              FinDimen.horizontal,
              FinDimen.vertical),
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
                          'Денис',
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
}
