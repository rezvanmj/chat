import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

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
    if (event is ChangeLoadingEvent) {
      // if data got from server is loading is false
      try {
        yield state.copyWith(isLoading: true);
        String token = await _authServiceRepository.signIn(
            userName: state.usernameController!.text.trim(),
            password: state.passwordController!.text.trim());

        // adding token to header
        getIt<Dio>()
            .options
            .headers
            .addAll({'x-devicetoken': 'c5406b71-e54f-46da-b512-0f31ddf95004'});
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
        print(e);
        print(s);
        yield state.copyWith(
            isLoading: false, apiResponse: ApiResponse(response: Failure(e)));
      } catch (e, s) {
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
