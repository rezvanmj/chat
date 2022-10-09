import 'package:dio/dio.dart';

abstract class AuthServiceRepository {
  Future<String> signIn({required String userName, required String password});
  Future<Map<String, dynamic>> getUserInfo();
  Future<Response> confirmDevice(String confirmCode, String userName);
}
