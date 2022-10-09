import 'package:flutter/cupertino.dart';

import '../../domain/core/enums.dart';

class LoginState {
  final bool? isLoading;
  final bool? isShowingPass;
  final ApiResponse? apiResponse;
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;

  LoginState({
    this.isLoading,
    this.apiResponse,
    this.isShowingPass,
    this.usernameController,
    this.passwordController,
  });

  static LoginState init() {
    return LoginState(
        isLoading: false,
        isShowingPass: false,
        apiResponse: ApiResponse(),
        usernameController: TextEditingController(),
        passwordController: TextEditingController());
  }

  LoginState copyWith({
    bool? isLoading,
    ApiResponse? apiResponse,
    TextEditingController? usernameController,
    TextEditingController? passwordController,
    bool? isShowingPass,
  }) {
    return LoginState(
      apiResponse: apiResponse ?? this.apiResponse,
      usernameController: usernameController ?? this.usernameController,
      passwordController: passwordController ?? this.passwordController,
      isLoading: isLoading ?? this.isLoading,
      isShowingPass: isShowingPass ?? this.isShowingPass,
    );
  }
}
