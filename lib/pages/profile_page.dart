import 'package:fin_clever/models/provider/operations.dart';
import 'package:fin_clever/models/provider/portfolio_info.dart';
import 'package:fin_clever/services/firebase_service.dart';
import 'package:fin_clever/utils/constants.dart';
import 'package:fin_clever/utils/helper.dart';
import 'package:fin_clever/widgets/title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider/accounts.dart';
import '../models/provider/current_user.dart';
import '../widgets/caption.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>().user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleAppBar(title: "Профиль"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user?.getAvatarUrl() ?? ""),
              ),
            ),
          ],
        ),
        caption('Имя'),
        Padding(
          padding: const EdgeInsets.only(
            left: FinDimen.horizontal,
            top: FinDimen.vertical,
            bottom: FinDimen.vertical,
          ),
          child: Text(user?.name ?? ""),
        ),
        caption('Email'),
        Padding(
          padding: const EdgeInsets.only(
            left: FinDimen.horizontal,
            top: FinDimen.vertical,
            bottom: FinDimen.vertical,
          ),
          child: Text(user?.email ?? ""),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            child: const Text('Выйти'),
            onPressed: () async {
              try {
                firebaseService.signOutFromGoogle();
                context.read<Operations>().clear();
                context.read<Accounts>().clear();
                context.read<CurrentUser>().clear();
                context.read<PortfolioInfo>().clear();
              } catch (e) {
                showToast(context, 'Не удалось выйти');
              }
            },
          ),
        )
      ],
    );
    ;
  }
}
