import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/service_locator.dart';
import '../../domain/core/enums.dart';
import '../../domain/login/auth_service_repository.dart';
import '../../domain/user/user_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthServiceRepository _authServiceRepository;

  LoginBloc({required AuthServiceRepository authServiceRepository})
      : _authServiceRepository = authServiceRepository,
        super(LoginState.init());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final prefs = await SharedPreferences.getInstance();

    if (event is ChangeLoadingEvent) {
      try {
        yield state.copyWith(isLoading: true);
        String token = await _authServiceRepository.signIn(
            userName: state.usernameController!.text.trim(),
            password: state.passwordController!.text.trim());

        await prefs.setString('token', token);
        // adding token to header

        getIt<Dio>().options.headers.addAll({'Authorization': 'Bearer $token'});
        // getting user
        final Map<String, dynamic> info =
            await _authServiceRepository.getUserInfo();
        // setting user global
        getIt.registerSingleton<UserModel>(UserModel.fromJson(info['user']));
        //
        yield state.copyWith(
            isLoading: false, apiResponse: ApiResponse(response: Success()));
      } on Exception catch (e, s) {
        await prefs.setString('token', '');
        print(e);
        print(s);
        yield state.copyWith(
            isLoading: false, apiResponse: ApiResponse(response: Failure(e)));
      } catch (e, s) {
        await prefs.setString('token', '');
        print(e);
        print(s);
        yield state.copyWith(
            isLoading: false, apiResponse: ApiResponse(response: Failure(e)));
      }
    } else if (event is ChangeVisiblityPassEvent) {
      bool isShow = !state.isShowingPass!;
      yield state.copyWith(isShowingPass: isShow);
    }
  }
}
