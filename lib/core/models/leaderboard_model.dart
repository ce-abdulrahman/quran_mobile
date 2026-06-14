class LeaderboardModel {
  final int rank;
  final int userId;
  final String name;
  final int score;
  final String movement; // up, down, none, new
  final bool isAnonymous;

  LeaderboardModel({
    required this.rank,
    required this.userId,
    required this.name,
    required this.score,
    required this.movement,
    required this.isAnonymous,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      score: json['score'] ?? 0,
      movement: json['movement'] ?? 'new',
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }
}
