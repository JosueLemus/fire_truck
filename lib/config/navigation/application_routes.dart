import 'package:bomberman/presentation/screens.dart';
import 'package:flutter/material.dart';

class Routes {
  static String home = 'home';
  static String login = 'login';
  static String main = 'main';
}

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const SplashScreen(),
    Routes.login: (BuildContext context) => const LoginScreen(),
    Routes.main: (BuildContext context) => const MainScreen(),
  };
}
