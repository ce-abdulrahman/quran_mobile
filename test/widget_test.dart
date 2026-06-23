import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/shell/app_shell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:quran_mobile/core/local_db/isar_service.dart';
import 'package:quran_mobile/core/local_db/isar_collections.dart';
import 'package:quran_mobile/core/providers/app_providers.dart';
import 'package:quran_mobile/core/network/api_client.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MockApiClient extends ApiClient {
  MockApiClient() : super();

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'status': 'success', 'data': []} as T,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'status': 'success', 'data': []} as T,
    );
  }
}

void main() {
  late Directory tempDir;
  late Box cacheBox;
  late Box prayerTimesBox;
  late SharedPreferences sharedPrefs;
  late ApiClient mockApiClient;

  setUpAll(() async {
    Animate.restartOnHotReload = true;
    HttpOverrides.global = null;
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('isar_test_widget_');
    final isar = await Isar.open(
      [
        SurahCollectionSchema,
        AyahCollectionSchema,
        TajweedRuleCollectionSchema,
        PrayerTimesCollectionSchema,
        MemorizationPlanCollectionSchema,
        MemorizationReviewCollectionSchema,
        TasbihSessionCollectionSchema,
        ReadingHistoryCollectionSchema,
        BookmarkCollectionSchema,
        NoteCollectionSchema,
      ],
      directory: tempDir.path,
    );
    IsarService.initForTest(isar);

    // Initialize Hive and SharedPreferences for testing
    Hive.init(tempDir.path);
    cacheBox = await Hive.openBox('app_cache_box');
    prayerTimesBox = await Hive.openBox('prayer_times_box');
    SharedPreferences.setMockInitialValues({});
    sharedPrefs = await SharedPreferences.getInstance();

    mockApiClient = MockApiClient();
  });

  testWidgets('App shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
          hiveCacheBoxProvider.overrideWithValue(cacheBox),
          prayerTimesHiveBoxProvider.overrideWithValue(prayerTimesBox),
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(AppShell), findsOneWidget);
  });
}
