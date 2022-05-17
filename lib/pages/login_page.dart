import 'package:fin_clever/data/models/app_user.dart';
import 'package:fin_clever/data/services/user_service.dart';
import 'package:fin_clever/utils/helper.dart';
import 'package:fin_clever/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fin_clever/data/services/firebase_service.dart';
import '../utils/constants.dart';
import '../fin_clever_icons_icons.dart';
import '../widgets/button.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseService _service = FirebaseService();
  final UserService _userService = UserService();
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
                      text: "Войти",
                      style: TextStyle(
                        color: FinColor.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ],
              ),
            ),
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
                obscuringEnabled: true,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            buildSignInButton(size: size),
            buildRowDivider(size: size),
            buildGoogleButton(size: size),
            buildSignUpButton(size: size),
          ],
        ),
      ),
    );
  }

  Widget buildRowDivider({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: Row(children: const <Widget>[
        Expanded(child: Divider(color: FinColor.darkBlue)),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Or",
            style: TextStyle(color: FinColor.darkBlue),
          ),
        ),
        Expanded(child: Divider(color: FinColor.darkBlue)),
      ]),
    );
  }

  Widget buildSignInButton({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: button(
        text: "Войти",
        onPressed: () async {
          try {
            await _service.signInWithEmail(email: email, password: password);
            await _userService.login();
          } catch (e) {
            showToast(context, "Ошибка авторизации, проверьте email и пароль");
          }
        },
      ),
    );
  }

  Widget buildSignUpButton({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: TextButton(
        child: Row(
          children: [
            Text(
              "Нет аккаунта? ",
              style: FinFont.regular.copyWith(color: FinColor.darkBlue),
            ),
            const Text("Зарегистрироваться"),
          ],
        ),
        onPressed: () async {
          _navigateToSignUp();
        },
      ),
    );
  }

  Widget buildGoogleButton({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: button(
        text: FinText.textSignInGoogle,
        onPressed: () async {
          try {
            await _service.signInWithGoogle();
            await _userService.login();
          } catch (e) {
            showToast(context, "Ошибка авторизации, попробуйте войти по email");
          }
        },
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => const SignUpPage()));
  }
}
