import 'package:fin_clever/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TitleAppBar(title: "Профиль"),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('В разработке...'),
        )
      ],
    );
  }
}
