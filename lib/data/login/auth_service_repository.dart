import 'package:dio/dio.dart';

import '../../domain/core/general_exceptions.dart';
import '../../domain/login/auth_exception.dart';
import '../../domain/login/auth_service_repository.dart';

const int ADMIN_ROLE_ID = 3;

class AuthServiceRepositoryImpl extends AuthServiceRepository {
  final Dio dio;

  AuthServiceRepositoryImpl(this.dio);

  // sign in
  @override
  Future<String> signIn(
      {required String userName, required String password}) async {
    try {
      final response = await dio.post('/api/user/login',
          data: {"username": userName, "password": password},
          options: Options(headers: {
            'x-devicetoken': 'c5406b71-e54f-46da-b512-0f31ddf95004'
          }));
      // if user is not admin
      if (response.data['user']?['frk_role'] != ADMIN_ROLE_ID) {
        throw NotAdminException();
      }
      return response.data['token'];
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 403) {
        throw NotTrustedException();
      } else if (e.response?.statusCode == 400) {
        throw InvalidEmailAndPasswordCombination();
      } else if (e.response?.statusCode == 404) {
        throw InvalidEmailAndPasswordCombination();
      } else if (e.response?.statusCode == 401) {
        throw IncorrectUsernameAndPasswordException();
      } else {
        throw getGeneralException(e);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      Response response = await dio.get('/api/user/info');
      return response.data;
    } catch (e) {
      throw getGeneralException(e);
    }
  }

  @override
  Future<Response> confirmDevice(String confirmCode, String userName) async {
    try {
      Map<String, dynamic> confirmData = {
        "confirm": confirmCode,
        "trusted": "1",
        "username": userName,
      };
      return await dio.post("/api/user/device/confirm", data: confirmData);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        throw NotTrustedException();
      } else {
        throw UnknownException();
      }
    } catch (e) {
      throw getGeneralException(e);
    }
  }
}
