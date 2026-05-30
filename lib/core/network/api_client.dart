import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    String message = 'هەڵەیەک لە پەیوەندیدا ڕوویدا'; // Default Kurdish error message
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'کاتی پەیوەندی بەستن بەسەرچوو';
        break;
      case DioExceptionType.sendTimeout:
        message = 'کاتی ناردنی داواکاری بەسەرچوو';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'کاتی وەرگرتنی وەڵام بەسەرچوو';
        break;
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        } else {
          message = 'وەڵامی نادروست لە سێرڤەرەوە: ${e.response?.statusCode}';
        }
        break;
      case DioExceptionType.cancel:
        message = 'داواکارییەکە هەڵوەشێندرایەوە';
        break;
      case DioExceptionType.connectionError:
        message = 'هێڵی ئینتەرنێت نییە یان سێرڤەر کار ناکات';
        break;
      default:
        message = 'هەڵەیەکی نەزانراو ڕوویدا';
        break;
    }
    
    return ApiException(message, statusCode: e.response?.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
