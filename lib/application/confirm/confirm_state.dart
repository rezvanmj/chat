import 'package:flutter/cupertino.dart';

import '../../domain/core/enums.dart';

class ConfirmState {
  final bool? isLoading;
  final ApiResponse? apiResponse;
  final TextEditingController? confirmCodeController;

  ConfirmState({this.isLoading, this.apiResponse, this.confirmCodeController});

  static ConfirmState init() {
    return ConfirmState(
      isLoading: false,
      confirmCodeController: TextEditingController(),
      apiResponse: ApiResponse(),
    );
  }

  ConfirmState copyWith(
      {bool? isLoading,
      ApiResponse? apiResponse,
      TextEditingController? confirmCodeController}) {
    return ConfirmState(
        isLoading: isLoading ?? this.isLoading,
        apiResponse: apiResponse ?? this.apiResponse,
        confirmCodeController:
            confirmCodeController ?? this.confirmCodeController);
  }
}
