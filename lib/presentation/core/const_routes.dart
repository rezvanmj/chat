import 'package:chat_project/presentation/login/login_view.dart';
import 'package:flutter/material.dart';

import '../confirm/confirm_view.dart';
import '../home/home_view.dart';
import '../unknown_page/uknown_route_page.dart';

const initPage = '/init';
const loginPage = '/login';
const confirmPage = '/confirm';
const homePage = '/home';

// generate routes
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case confirmPage:
      return MaterialPageRoute(builder: (context) => const ConfirmView());
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomeView());
    default:
      return MaterialPageRoute(builder: (context) => const UnknownRoutePage());
  }
}
