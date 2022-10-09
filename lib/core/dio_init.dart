import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../presentation/core/const_routes.dart';
import 'service_locator.dart';

const String CDNBaseUrl = 'https://hillzimage.blob.core.windows.net';
// const String BaseUrl = 'https://api.hillzusers.com';
const String BaseUrl = 'https://test111web.ca';

Future initDio() async {
  print('HELLO INITDIO');
  Dio dio = getIt<Dio>();
  dio.options.baseUrl = BaseUrl;
  final sp = await SharedPreferences.getInstance();
  dio.options.connectTimeout = 30000;
  dio.options.receiveTimeout = 30000;
  PrettyDioLogger prettyDioLogger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
    request: true,
  );
  // setting trusted device token if exist
  final xDeviceToken = sp.getString('x-devicetoken');
  if (xDeviceToken != null) {
    dio.options.headers
        .addAll({'x-devicetoken': 'c5406b71-e54f-46da-b512-0f31ddf95004'});
  }
  // setting logger
  dio.interceptors.add(prettyDioLogger);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (res, handler) {
        print('headers : ');
        print(res.headers);
        print('body: ');
        print(res.data);
        handler.next(res);
      },
      onError: (DioError error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          navigatorKey.currentState!.popUntil((route) => true);
          navigatorKey.currentState!.pushNamed(initPage);
        } else {
          handler.next(error);
        }
      },
      onResponse: (dynamic response, ResponseInterceptorHandler handler) {
        handler.next(response);
      },
    ),
  );
}
