/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Konfigurasi Dio: base URL DummyJSON, timeout, header JSON, dan logging
class DioClient {
  static const String baseUrl = 'https://dummyjson.com';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor untuk mencatat request, response, dan error di Debug Console
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('[CrinEar API] --> ${options.method} ${options.uri}');
            if (options.data != null) {
              debugPrint('[CrinEar API] body: ${options.data}');
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[CrinEar API] <-- ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[CrinEar API] ERROR ${error.response?.statusCode ?? '-'} '
              '${error.type.name} ${error.requestOptions.uri}',
            );
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
