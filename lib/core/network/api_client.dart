import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio, String Function()? tokenProvider}) : _dio = dio ?? _createDio(tokenProvider);

  static Dio _createDio([String Function()? tokenProvider]) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Accept 304 Not Modified as a valid response (ETag caching)
        // 304 is < 400 but Dio treats it as error by default when validateStatus returns false
        validateStatus: (status) => status != null && (status < 400 || status == 304),
      ),
    );

    if (tokenProvider != null) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final token = tokenProvider();
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
        ),
      );
    }

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

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
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

  Future<void> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
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
