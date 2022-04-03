import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TitleAppBar extends StatelessWidget {
  const TitleAppBar({
    Key? key,
    required this.title,
    this.getResult
  }) : super(key: key);

  final String title;
  final bool Function()? getResult;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
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
            12,
            FinDimen.vertical + FinDimen.statusBarHeight,
            FinDimen.horizontal,
            FinDimen.vertical,
          ),
          child: Row(children: [
            if (canPop) ...[
              IconButton(
                onPressed: () {
                  Navigator.maybePop(context, getResult?.call());
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                iconSize: 24,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: FinColor.darkBlue,
              )
            ],
            Container(
              margin: const EdgeInsets.only(left: 12, bottom: 3),
              child: Text(
                title,
                style: FinFont.semibold.copyWith(fontSize: 24),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
