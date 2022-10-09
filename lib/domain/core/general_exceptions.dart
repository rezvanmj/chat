// general exceptions that the application might throw

import 'dart:io';

import 'package:dio/dio.dart';

class NoConnectionException implements Exception {
  @override
  String toString() {
    return 'You are not connected to internet';
  }
}

class NotTrustedException implements Exception {
  @override
  String toString() {
    return "Your device is not trusted";
  }
}

class NoInternetException implements Exception {
  @override
  String toString() {
    return 'You are not connected to internet';
  }
}

class ServerInternalException implements Exception {
  @override
  String toString() {
    return 'Server does not response. try again after a few moment.';
  }
}

class UnknownException implements Exception {
  @override
  String toString() {
    return 'Unknown error has occurred,contact support for more information';
  }
}

class BadRequestException implements Exception {
  @override
  String toString() {
    return 'The server cannot process the request';
  }
}

class BadJsonFormatException implements Exception {
  @override
  String toString() {
    return 'Bad Request, Processing server response failed';
  }
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}
/// Using this method to extract an exception from a server response
/// if doesn't exist it return [UnknownException]
Exception getGeneralException(dynamic e) {
  // if e is already an Exception

  try{
    if (e.response?.statusCode != null) {
      if (e.response!.statusCode == 400) {
        try {
          if (e.response!.data['message'] != null) {
            return CustomException(e.response!.data['message'].toString());
          }
        } catch (e) {}
        return BadRequestException();
      }
      if (e.response!.statusCode == 403) {
        return NotTrustedException();
      }
      if (e.response!.statusCode >= 500) return ServerInternalException();
    }
    if (e is FormatException) return BadJsonFormatException();
    if (e is TypeError) return BadJsonFormatException();
    if (e is NoSuchMethodError) return BadJsonFormatException();
    if (e.error is SocketException) return NoConnectionException();
    if (e.type == DioErrorType.connectTimeout) return NoInternetException();
    if(e is Exception){
      return e;
    }
  }catch(e){
    return UnknownException();
  }

  return UnknownException();

}
