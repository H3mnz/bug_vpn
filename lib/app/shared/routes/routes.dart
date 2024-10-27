import 'package:flutter/material.dart';

import '../../ui/home/view/pages/home.dart';
import '../../ui/home/view/pages/splash.dart';

class AppRoutes {
  AppRoutes._();
  static const String splashRoute = '/';
  static const String homeRoute = '/home';

  static Map<String, WidgetBuilder> routes = {
    splashRoute: (context) => const SplashPage(),
    homeRoute: (context) => const HomePage(),
  };
}
