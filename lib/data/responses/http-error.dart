


import 'package:dio/dio.dart';

class HttpError {
  late final int status;
  late final String code;
  late final String description;

  HttpError({required this.status, required this.code, required this.description});

  HttpError.fromDioError (error){
    if(error is TypeError){
      throw error;
    }
    if(error?.response?.data is String) {
      throw error?.response?.data;
    }
    final data = Map.from(error?.response?.data ?? {})['error'];
    status = data['status'] ?? error.response?.statusCode ?? -1;
    code = data['code'] ?? 'UNKNOWN';
    description = data['description'] ?? 'Unknown error';
  }
}