import 'package:fin_clever/data/models/operation.dart';
import 'package:fin_clever/data/models/provider/operations.dart';
import 'package:fin_clever/data/models/provider/portfolio_info.dart';
import 'package:fin_clever/data/services/firebase_service.dart';
import 'package:fin_clever/utils/constants.dart';
import 'package:fin_clever/utils/helper.dart';
import 'package:fin_clever/widgets/junk_categories_selector.dart';
import 'package:fin_clever/widgets/title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fin_clever_icons_icons.dart';
import '../data/models/provider/accounts.dart';
import '../data/models/provider/current_user.dart';
import '../widgets/caption.dart';
import '../widgets/text_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleAppBar(title: "Профиль"),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(user.user?.getAvatarUrl() ?? ""),
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
                  child: Text(user.user?.name ?? ""),
                ),
                caption('Email'),
                Padding(
                  padding: const EdgeInsets.only(
                    left: FinDimen.horizontal,
                    top: FinDimen.vertical,
                    bottom: FinDimen.vertical,
                  ),
                  child: Text(user.user?.email ?? ""),
                ),
                caption('Нежелательные категории'),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: JunkCategorySelector(categories: expenseCategories),
                ),
                caption('Допустимые расходы на нежелательные категории'),
                Padding(
                  padding: const EdgeInsets.only(
                    left: FinDimen.horizontal,
                    bottom: FinDimen.vertical,
                  ),
                  child: TextInput(
                    icon: FinCleverIcons.ic_initial_amount,
                    hint: 'Лимит в месяц',
                    text: (user.user?.junkLimit.compareTo(0) != 0) ? user.user?.junkLimit.toString() ?? "" : "",
                    keyboardType: TextInputType.number,
                    onChanged: (s) {
                      user.updateUser(user.user?.copyWith(
                          junkLimit: double.parse(s.replaceAll(',', '.'))), sendToServer: true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: FinDimen.vertical,
                    bottom: FinDimen.vertical,
                  ),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
