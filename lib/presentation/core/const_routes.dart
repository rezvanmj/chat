import 'package:chat_project/presentation/chat_room/chat_room_view.dart';
import 'package:chat_project/presentation/login/login_view.dart';
import 'package:flutter/material.dart';

import '../confirm/confirm_view.dart';
import '../home/home_view.dart';
import '../unknown_page/uknown_route_page.dart';

// const initPage = '/init';
const loginPage = '/login';
const confirmPage = '/confirm';
const homePage = '/home';
const chatRoomPage = '/chat-room';

// generate routes
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case confirmPage:
      return MaterialPageRoute(builder: (context) => const ConfirmView());
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case chatRoomPage:
      final Map args = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) => ChatRoomView(chatRoom: args['chatRoomId']));
    default:
      return MaterialPageRoute(builder: (context) => const UnknownRoutePage());
  }
}
