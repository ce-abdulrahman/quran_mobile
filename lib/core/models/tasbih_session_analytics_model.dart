class TasbihSessionAnalyticsModel {
  final Map<String, dynamic> overview;
  final List<Map<String, dynamic>> dailyTrends;
  final Map<int, int> hourlyPeaks;
  final Map<String, int> ratesDistribution;

  const TasbihSessionAnalyticsModel({
    required this.overview,
    required this.dailyTrends,
    required this.hourlyPeaks,
    required this.ratesDistribution,
  });

  factory TasbihSessionAnalyticsModel.fromJson(Map<String, dynamic> json) {
    // Parse hourly peaks map safely
    final rawHourly = json['hourly_peaks'] as Map<String, dynamic>? ?? {};
    final Map<int, int> parsedHourly = {};
    for (int h = 0; h < 24; h++) {
      parsedHourly[h] = (rawHourly[h.toString()] ?? 0) as int;
    }

    final rawTrends = json['daily_trends'] as List<dynamic>? ?? [];
    final List<Map<String, dynamic>> parsedTrends = rawTrends.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    final rawRates = json['rates_distribution'] as Map<String, dynamic>? ?? {};
    final Map<String, int> parsedRates = {
      'slow': (rawRates['slow'] ?? 0) as int,
      'medium': (rawRates['medium'] ?? 0) as int,
      'fast': (rawRates['fast'] ?? 0) as int,
    };

    return TasbihSessionAnalyticsModel(
      overview: Map<String, dynamic>.from(json['overview'] as Map? ?? {}),
      dailyTrends: parsedTrends,
      hourlyPeaks: parsedHourly,
      ratesDistribution: parsedRates,
    );
  }
}
