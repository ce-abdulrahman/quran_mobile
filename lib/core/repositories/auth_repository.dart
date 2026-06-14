import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// User Login
  Future<ApiResult<Map<String, dynamic>>> login({
    required String login,
    required String password,
    String? deviceIdentifier,
    String? deviceName,
    String? platform,
    String? platformVersion,
    String? pushToken,
    Map<String, dynamic>? guestData,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {
          'login': login,
          'password': password,
          if (deviceIdentifier != null) 'device_identifier': deviceIdentifier,
          if (deviceName != null) 'device_name': deviceName,
          if (platform != null) 'platform': platform,
          if (platformVersion != null) 'last_platform_version': platformVersion,
          if (pushToken != null) 'push_token': pushToken,
          if (guestData != null) 'guest_data': guestData,
        },
      );
      
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;
        final stats = data['stats'] as Map<String, dynamic>? ?? {};
        
        return ApiSuccess({
          'user': user,
          'token': token,
          'stats': stats,
        });
      } else {
        return const ApiError('هەڵەیەک لە چوونەژوورەوەدا ڕوویدا');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// User Registration
  Future<ApiResult<Map<String, dynamic>>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? gender,
    int? birthYear,
    int? countryId,
    int? provinceId,
    String? avatarPath,
    String? deviceIdentifier,
    String? deviceName,
    String? platform,
    String? platformVersion,
    String? pushToken,
    Map<String, dynamic>? guestData,
  }) async {
    try {
      MultipartFile? avatarFile;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        avatarFile = await MultipartFile.fromFile(
          avatarPath,
          filename: avatarPath.split('/').last,
        );
      }

      final formDataMap = {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (gender != null) 'gender': gender,
        if (birthYear != null) 'birth_year': birthYear.toString(),
        if (countryId != null) 'country_id': countryId.toString(),
        if (provinceId != null) 'province_id': provinceId.toString(),
        if (avatarFile != null) 'avatar': avatarFile,
        if (deviceIdentifier != null) 'device_identifier': deviceIdentifier,
        if (deviceName != null) 'device_name': deviceName,
        if (platform != null) 'platform': platform,
        if (platformVersion != null) 'last_platform_version': platformVersion,
        if (pushToken != null) 'push_token': pushToken,
        if (guestData != null) 'guest_data': guestData, // wait, FormData maps nested arrays differently. We can send guest_data as json or serialize it.
      };

      final response = await _apiClient.post(
        ApiConstants.authRegister,
        data: FormData.fromMap(formDataMap),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;
        final stats = data['stats'] as Map<String, dynamic>? ?? {};

        return ApiSuccess({
          'user': user,
          'token': token,
          'stats': stats,
        });
      } else {
        return const ApiError('هەڵەیەک لە دروستکردنی ئەکاونتدا ڕوویدا');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get Current User Profile
  Future<ApiResult<Map<String, dynamic>>> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.authProfile);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final stats = data['stats'] as Map<String, dynamic>? ?? {};
        return ApiSuccess({
          'user': user,
          'stats': stats,
        });
      } else {
        return const ApiError('ناتوانرێت زانیارییەکانی پرۆفایل وەربگیرێت');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Update User Profile
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    String? name,
    String? username,
    String? email,
    String? gender,
    int? birthYear,
    int? countryId,
    int? provinceId,
    String? avatarPath,
    String? bio,
    String? nickname,
    String? publicTitle,
    String? profileQuote,
    Map<String, dynamic>? translations,
  }) async {
    try {
      MultipartFile? avatarFile;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        avatarFile = await MultipartFile.fromFile(
          avatarPath,
          filename: avatarPath.split('/').last,
        );
      }

      final formDataMap = {
        if (name != null) 'name': name,
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (gender != null) 'gender': gender,
        if (birthYear != null) 'birth_year': birthYear.toString(),
        if (countryId != null) 'country_id': countryId.toString(),
        if (provinceId != null) 'province_id': provinceId.toString(),
        if (avatarFile != null) 'avatar': avatarFile,
        if (bio != null) 'bio': bio,
        if (nickname != null) 'nickname': nickname,
        if (publicTitle != null) 'public_title': publicTitle,
        if (profileQuote != null) 'profile_quote': profileQuote,
      };

      // Handle translations or complex fields. If there are translations, we can append them or upload via JSON if no files are uploaded.
      // But since we want to support both avatar upload and profile update, we can serialize translation arrays manually or do multipart request.
      // Let's do multipart if avatarFile is present, else normal PUT request.
      Response response;
      if (avatarFile != null) {
        final formData = FormData.fromMap(formDataMap);
        if (translations != null) {
          // Serialize translations map for form data: e.g. translations[ku][bio] = 'وەسف'
          translations.forEach((lang, fields) {
            if (fields is Map) {
              fields.forEach((field, val) {
                formData.fields.add(MapEntry('translations[$lang][$field]', val.toString()));
              });
            }
          });
        }
        // Multipart requires POST with _method=PUT to emulate PUT request in Laravel
        formData.fields.add(const MapEntry('_method', 'PUT'));
        response = await _apiClient.post(
          ApiConstants.authProfileUpdate,
          data: formData,
        );
      } else {
        // Standard JSON PUT request
        final dataMap = Map<String, dynamic>.from(formDataMap);
        if (translations != null) {
          dataMap['translations'] = translations;
        }
        response = await _apiClient.put(
          ApiConstants.authProfileUpdate,
          data: dataMap,
        );
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final stats = data['stats'] as Map<String, dynamic>? ?? {};

        return ApiSuccess({
          'user': user,
          'stats': stats,
        });
      } else {
        return const ApiError('نوێکردنەوەی پرۆفایل سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Change User Password
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authChangePassword,
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return const ApiSuccess(null);
      } else {
        return const ApiError('گۆڕینی شیکارە سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Convert Guest profile progress
  Future<ApiResult<UserModel>> guestConvert({
    required Map<String, dynamic> guestData,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authGuestConvert,
        data: {
          'guest_data': guestData,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return ApiSuccess(user);
      } else {
        return const ApiError('گواستنەوەی پێشکەوتنی مێوان سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Delete Account (Soft Delete)
  Future<ApiResult<void>> deleteAccount() async {
    try {
      final response = await _apiClient.delete(ApiConstants.authAccountDelete);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return const ApiSuccess(null);
      } else {
        return const ApiError('سڕینەوەی ئەکاونت سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Logout current device session
  Future<ApiResult<void>> logout({String? deviceIdentifier}) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authLogout,
        data: {
          if (deviceIdentifier != null) 'device_identifier': deviceIdentifier,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return const ApiSuccess(null);
      } else {
        return const ApiError('چوونەدەرەوە سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Logout all device sessions
  Future<ApiResult<void>> logoutAll() async {
    try {
      final response = await _apiClient.post(ApiConstants.authLogoutAll);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return const ApiSuccess(null);
      } else {
        return const ApiError('چوونەدەرەوە لە هەموو ئامێرەکان سەرکەوتوو نەبوو');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch Countries
  Future<ApiResult<List<Map<String, dynamic>>>> getCountries() async {
    try {
      final response = await _apiClient.get(ApiConstants.authCountries);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final list = (responseData['data'] as List).cast<Map<String, dynamic>>();
        return ApiSuccess(list);
      } else {
        return const ApiError('هەڵەیەک لە هێنانی لیستى وڵاتەکاندا هەیە');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch Provinces
  Future<ApiResult<List<Map<String, dynamic>>>> getProvinces(int countryId) async {
    try {
      final response = await _apiClient.get(ApiConstants.authProvinces(countryId));
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final list = (responseData['data'] as List).cast<Map<String, dynamic>>();
        return ApiSuccess(list);
      } else {
        return const ApiError('هەڵەیەک لە هێنانی لیستى شارەکاندا هەیە');
      }
    } on ApiException catch (e) {
      return ApiError(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
