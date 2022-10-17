import 'package:chat_project/application/home/home_state.dart';
import 'package:chat_project/data/file/send_file_repository_imp.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../application/chat_room/chat_room_bloc.dart';
import '../application/confirm/confirm_bloc.dart';
import '../application/home/home_bloc.dart';
import '../application/login/login_bloc.dart';
import '../data/login/auth_service_repository.dart';
import '../domain/chat_room/send_file_repository.dart';
import '../domain/login/auth_service_repository.dart';

final getIt = GetIt.instance;
late IO.Socket socket;
void setUpGetIt() {
  getIt.allowReassignment = true;
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<AuthServiceRepository>(
      AuthServiceRepositoryImpl(getIt<Dio>()));

  getIt.registerSingleton<SendFileRepository>(
      SendFileRepositoryImp(getIt<Dio>()));

  getIt.registerFactory<LoginBloc>(
      () => LoginBloc(authServiceRepository: getIt<AuthServiceRepository>()));

  getIt.registerFactory<HomeBloc>(() => HomeBloc(HomeState.init()));

  getIt.registerFactory<ChatRoomBloc>(
      () => ChatRoomBloc(ChatRoomState.init(), getIt<SendFileRepository>()));

  getIt.registerFactory<ConfirmBloc>(
      () => ConfirmBloc(authServiceRepository: getIt<AuthServiceRepository>()));
}
