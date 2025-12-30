import 'package:axel/core/config/env_config.dart';
import 'package:axel/core/network/api_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 600,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await EnvConfig.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) {
          handler.reject(e.copyWith(error: handleDioError(e)));
        },
      ),
    );

    if (appFlavor == "staging") {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  // ---------- PUBLIC API ----------

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      endpoint,
      method: 'GET',
      queryParams: queryParams,
      headers: headers,
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      endpoint,
      method: 'POST',
      data: data,
      queryParams: queryParams,
      headers: headers,
    );
  }

  // ---------- CORE REQUEST ----------

  Future<Response<T>> _request<T>(
    String endpoint, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      method: method,
      headers: {...dio.options.headers, if (headers != null) ...headers},
    );

    return dio.request<T>(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: options,
    );
  }
}
