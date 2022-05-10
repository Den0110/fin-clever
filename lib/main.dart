import 'dart:io';
import 'package:fin_clever/models/app_user.dart';
import 'package:fin_clever/models/provider/portfolio_info.dart';
import 'package:fin_clever/pages/home_page.dart';
import 'package:fin_clever/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/provider/current_user.dart';
import 'utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/provider/accounts.dart';
import 'models/provider/operations.dart';
import 'services/user_service.dart';

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  if (!kReleaseMode) {
    HttpOverrides.global = DebugHttpOverrides();
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUser>(
          create: (BuildContext context) => CurrentUser(),
        ),
        ChangeNotifierProvider<Operations>(
          create: (BuildContext context) => Operations(),
        ),
        ChangeNotifierProvider<Accounts>(
          create: (BuildContext context) => Accounts(),
        ),
        ChangeNotifierProvider<PortfolioInfo>(
          create: (BuildContext context) => PortfolioInfo(),
        ),
      ],
      child: const FinCleverApp(),
    ),
  );
}

class FinCleverApp extends StatefulWidget {
  const FinCleverApp({Key? key}) : super(key: key);

  @override
  _FinCleverAppState createState() => _FinCleverAppState();
}

class _FinCleverAppState extends State<FinCleverApp> {
  final _userService = UserService();

  @override
  initState() {
    super.initState();
    initializeDateFormatting('ru');
    Intl.defaultLocale = 'ru';
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      context.read<CurrentUser>().updateUser(AppUser.fromFirebaseUser(user));
      if (user != null) {
        _userService.loadUser().then((user) {
          context.read<CurrentUser>().updateUser(user);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinClever',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: FinColor.mainColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
              bodyColor: FinColor.darkBlue,
              displayColor: FinColor.darkBlue,
            ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      home: context.watch<CurrentUser>().user != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
