part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetChatRoomsEvent extends HomeEvent {}

class SendMessageEvent extends HomeEvent {}

class DisConnectSocket extends HomeEvent {}

class ReceiveMessageEvent extends HomeEvent {}

class DeleteChatRoom extends HomeEvent {}
