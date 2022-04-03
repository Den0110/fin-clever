import 'package:fin_clever/models/app_user.dart';
import 'package:fin_clever/models/provider/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fin_clever_icons_icons.dart';
import '../services/firebase_service.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import '../widgets/button.dart';
import '../widgets/text_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final UserService _userService = UserService();
  String name = "";
  String email = "";
  String password = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Новый аккаунт",
                      style: TextStyle(
                        color: FinColor.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.8,
              child: TextInput(
                icon: FinCleverIcons.ic_name,
                hint: 'Имя',
                onChanged: (s) {
                  setState(() {
                    name = s.trim();
                  });
                },
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.8,
              child: TextInput(
                icon: FinCleverIcons.ic_email,
                hint: 'Email',
                onChanged: (s) {
                  setState(() {
                    email = s.trim();
                  });
                },
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.8,
              child: TextInput(
                icon: FinCleverIcons.ic_password,
                hint: 'Пароль',
                onChanged: (s) {
                  setState(() {
                    password = s.trim();
                  });
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            _buildSignUpButton(size: size),
            _buildBackButton(size: size),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: button(
        text: "Зарегистрироваться",
        onPressed: () async {
          if (name.isEmpty) {
            showToast(context, "Введите имя");
            return;
          }
          if (email.isEmpty) {
            showToast(context, "Введите email");
            return;
          }
          if (password.isEmpty) {
            showToast(context, "Введите пароль");
            return;
          }
          try {
            await _firebaseService.signUp(email: email, password: password);
            final user = await _userService.signUp(AppUser("", name, email, ""));
            context.read<CurrentUser>().updateUser(user);
            Navigator.maybePop(context);
          } catch (e) {
            if (e is FirebaseAuthException) {
              showToast(context, e.message!);
            }
          }
        },
      ),
    );
  }

  Widget _buildBackButton({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: TextButton(
        child: const Text("Назад"),
        onPressed: () async {
          Navigator.maybePop(context);
        },
      ),
    );
  }
}
