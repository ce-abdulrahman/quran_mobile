class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? gender;
  final int? birthYear;
  final int? countryId;
  final int? provinceId;
  final String? avatar;
  final String role;
  final bool status;
  final String? preferredLocale;
  final int pointsTotal;
  final int streakDays;
  final int longestStreak;
  final int profileCompletionPercentage;
  final UserProfileModel? profile;
  final LocationModel? country;
  final LocationModel? province;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.gender,
    this.birthYear,
    this.countryId,
    this.provinceId,
    this.avatar,
    required this.role,
    required this.status,
    this.preferredLocale,
    required this.pointsTotal,
    required this.streakDays,
    required this.longestStreak,
    required this.profileCompletionPercentage,
    this.profile,
    this.country,
    this.province,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String?,
      birthYear: json['birth_year'] as int?,
      countryId: json['country_id'] as int?,
      provinceId: json['province_id'] as int?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'user',
      status: json['status'] == 1 || json['status'] == true,
      preferredLocale: json['preferred_locale'] as String?,
      pointsTotal: json['points_total'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      profileCompletionPercentage: json['profile_completion_percentage'] as int? ?? 0,
      profile: json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : null,
      country: json['country'] != null ? LocationModel.fromJson(json['country']) : null,
      province: json['province'] != null ? LocationModel.fromJson(json['province']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'gender': gender,
      'birth_year': birthYear,
      'country_id': countryId,
      'province_id': provinceId,
      'avatar': avatar,
      'role': role,
      'status': status,
      'preferred_locale': preferredLocale,
      'points_total': pointsTotal,
      'streak_days': streakDays,
      'longest_streak': longestStreak,
      'profile_completion_percentage': profileCompletionPercentage,
      'profile': profile?.toJson(),
      'country': country?.toJson(),
      'province': province?.toJson(),
    };
  }
}

class UserProfileModel {
  final int id;
  final int userId;
  final String? bio;
  final String? nickname;
  final String? publicTitle;
  final String? profileQuote;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? settings;
  final List<TranslationModel> translations;

  UserProfileModel({
    required this.id,
    required this.userId,
    this.bio,
    this.nickname,
    this.publicTitle,
    this.profileQuote,
    this.preferences,
    this.settings,
    required this.translations,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    var trList = json['translations'] as List?;
    List<TranslationModel> trModels = trList != null
        ? trList.map((i) => TranslationModel.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return UserProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      bio: json['bio'] as String?,
      nickname: json['nickname'] as String?,
      publicTitle: json['public_title'] as String?,
      profileQuote: json['profile_quote'] as String?,
      preferences: json['preferences'] is Map<String, dynamic> ? json['preferences'] as Map<String, dynamic>? : null,
      settings: json['settings'] is Map<String, dynamic> ? json['settings'] as Map<String, dynamic>? : null,
      translations: trModels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'nickname': nickname,
      'public_title': publicTitle,
      'profile_quote': profileQuote,
      'preferences': preferences,
      'settings': settings,
      'translations': translations.map((e) => e.toJson()).toList(),
    };
  }

  String getLocalizedBio(String locale, {String fallback = ''}) {
    return _getLocalizedField('bio', locale, fallback: fallback);
  }

  String getLocalizedNickname(String locale, {String fallback = ''}) {
    return _getLocalizedField('nickname', locale, fallback: fallback);
  }

  String _getLocalizedField(String fieldName, String locale, {String fallback = ''}) {
    for (var tr in translations) {
      if (tr.field == fieldName && tr.langCode == locale) {
        return tr.value;
      }
    }
    if (fieldName == 'bio') return bio ?? fallback;
    if (fieldName == 'nickname') return nickname ?? fallback;
    return fallback;
  }
}

class LocationModel {
  final int id;
  final String? code;
  final List<TranslationModel> translations;

  LocationModel({
    required this.id,
    this.code,
    required this.translations,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    var trList = json['translations'] as List?;
    List<TranslationModel> trModels = trList != null
        ? trList.map((i) => TranslationModel.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return LocationModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      translations: trModels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'translations': translations.map((e) => e.toJson()).toList(),
    };
  }

  String getLocalizedName(String locale) {
    for (var tr in translations) {
      if (tr.field == 'name' && tr.langCode == locale) {
        return tr.value;
      }
    }
    for (var tr in translations) {
      if (tr.field == 'name' && (tr.langCode == 'en' || tr.langCode == '1')) {
        return tr.value;
      }
    }
    return '';
  }
}

class TranslationModel {
  final int id;
  final String field;
  final String value;
  final String? langCode;

  TranslationModel({
    required this.id,
    required this.field,
    required this.value,
    this.langCode,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    String? code;
    if (json['language'] != null && json['language']['code'] != null) {
      code = json['language']['code'] as String;
    } else if (json['language_code'] != null) {
      code = json['language_code'] as String;
    }
    return TranslationModel(
      id: json['id'] as int? ?? 0,
      field: json['field'] as String? ?? '',
      value: json['value'] as String? ?? '',
      langCode: code,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'value': value,
      'language_code': langCode,
    };
  }
}
