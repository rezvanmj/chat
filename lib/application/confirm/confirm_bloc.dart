import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../core/service_locator.dart';
import '../../domain/core/enums.dart';
import '../../domain/login/auth_service_repository.dart';
import '../../domain/user/user_model.dart';
import 'confirm_event.dart';
import 'confirm_state.dart';

class ConfirmBloc extends Bloc<ConfirmEvent, ConfirmState> {
  final AuthServiceRepository _authServiceRepository;

  ConfirmBloc({required AuthServiceRepository authServiceRepository})
      : _authServiceRepository = authServiceRepository,
        super(ConfirmState.init());

  @override
  Stream<ConfirmState> mapEventToState(ConfirmEvent event) async* {
    if (event is ConfirmEvent) {
      try {
        yield state.copyWith(isLoading: true);
        Response res = await _authServiceRepository.confirmDevice(
            state.confirmCodeController!.text, 'poryazln');
        // String token = await _authServiceRepository.signIn(
        //     userName: state.usernameController!.text.trim(),
        //     password: state.passwordController!.text.trim());
        String token = res.data['token'];
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
    }
  }
}
