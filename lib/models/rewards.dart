class RewardsState {
  const RewardsState({
    this.coins = 0,
    this.stars = 0,
    this.xp = 0,
    this.dailyStreak = 0,
    this.lastPlayDay = '',
    this.badges = const {},
    this.playsToday = const {},
  });

  final int coins;
  final int stars;
  final int xp;
  final int dailyStreak;
  final String lastPlayDay;
  final Set<String> badges;
  final Map<String, int> playsToday;

  static const freePlaysPerGame = 5;

  int playsFor(String gameId) => playsToday[gameId] ?? 0;

  bool canPlay(String gameId, {required bool isPremium}) {
    if (isPremium) return true;
    return playsFor(gameId) < freePlaysPerGame;
  }

  int remainingPlays(String gameId, {required bool isPremium}) {
    if (isPremium) return 999;
    return (freePlaysPerGame - playsFor(gameId)).clamp(0, freePlaysPerGame);
  }

  RewardsState copyWith({
    int? coins,
    int? stars,
    int? xp,
    int? dailyStreak,
    String? lastPlayDay,
    Set<String>? badges,
    Map<String, int>? playsToday,
  }) {
    return RewardsState(
      coins: coins ?? this.coins,
      stars: stars ?? this.stars,
      xp: xp ?? this.xp,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastPlayDay: lastPlayDay ?? this.lastPlayDay,
      badges: badges ?? this.badges,
      playsToday: playsToday ?? this.playsToday,
    );
  }

  Map<String, dynamic> toJson() => {
    'coins': coins,
    'stars': stars,
    'xp': xp,
    'dailyStreak': dailyStreak,
    'lastPlayDay': lastPlayDay,
    'badges': badges.toList(),
    'playsToday': playsToday,
  };

  factory RewardsState.fromJson(Map<String, dynamic> json) {
    final badgeList = (json['badges'] as List?)?.cast<String>() ?? const [];
    final plays = (json['playsToday'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        ) ??
        const <String, int>{};
    return RewardsState(
      coins: (json['coins'] as int?) ?? 0,
      stars: (json['stars'] as int?) ?? 0,
      xp: (json['xp'] as int?) ?? 0,
      dailyStreak: (json['dailyStreak'] as int?) ?? 0,
      lastPlayDay: (json['lastPlayDay'] as String?) ?? '',
      badges: badgeList.toSet(),
      playsToday: Map<String, int>.from(plays),
    );
  }
}

class SessionResult {
  const SessionResult({
    required this.gameId,
    required this.correctSorts,
    required this.categoryCounts,
    required this.coinsEarned,
    required this.starsEarned,
    required this.xpEarned,
    required this.longestStreak,
    required this.newBadges,
  });

  final String gameId;
  final int correctSorts;
  final Map<String, int> categoryCounts;
  final int coinsEarned;
  final int starsEarned;
  final int xpEarned;
  final int longestStreak;
  final List<String> newBadges;
}
