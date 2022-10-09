import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../application/confirm/confirm_bloc.dart';
import '../application/login/login_bloc.dart';
import '../data/login/auth_service_repository.dart';
import '../domain/login/auth_service_repository.dart';

final getIt = GetIt.instance;

void setUpGetIt() {
  getIt.allowReassignment = true;
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<AuthServiceRepository>(
      AuthServiceRepositoryImpl(getIt<Dio>()));

  getIt.registerFactory<LoginBloc>(
      () => LoginBloc(authServiceRepository: getIt<AuthServiceRepository>()));

  getIt.registerFactory<ConfirmBloc>(
      () => ConfirmBloc(authServiceRepository: getIt<AuthServiceRepository>()));
}
