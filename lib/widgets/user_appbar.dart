import 'package:cached_network_image/cached_network_image.dart';
import 'package:fin_clever/data/models/app_user.dart';
import 'package:fin_clever/data/models/provider/current_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../utils/constants.dart';
import '../utils/date.dart';

AppBar userAppBar(BuildContext context) {
  final user = context.watch<CurrentUser>().user;
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
            CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(user?.getAvatarUrl() ?? ""),
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
                        '${MyDateUtils.getGreetingByTime()},',
                        style: FinFont.regular.copyWith(fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        user?.getDisplayName() ?? "",
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
