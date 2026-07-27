/// Shared session-duration presets for Parent Zone (1–30 minutes).
abstract final class GameDuration {
  static const presetsSeconds = <int>[
    60, // 1 min
    120, // 2
    180, // 3
    300, // 5
    600, // 10
    900, // 15
    1200, // 20
    1500, // 25
    1800, // 30
  ];

  static const minSeconds = 60;
  static const maxSeconds = 1800;

  /// Snaps an arbitrary second value to the nearest allowed preset.
  static int snap(int seconds) {
    final clamped = seconds.clamp(minSeconds, maxSeconds);
    var best = presetsSeconds.first;
    var bestDist = (clamped - best).abs();
    for (final p in presetsSeconds.skip(1)) {
      final d = (clamped - p).abs();
      if (d < bestDist) {
        best = p;
        bestDist = d;
      }
    }
    return best;
  }

  /// Slider index 0..presets.length-1.
  static int indexOf(int seconds) {
    final snapped = snap(seconds);
    return presetsSeconds.indexOf(snapped).clamp(0, presetsSeconds.length - 1);
  }

  static int fromIndex(int index) =>
      presetsSeconds[index.clamp(0, presetsSeconds.length - 1)];

  static String label(int seconds) {
    final s = snap(seconds);
    final mins = s ~/ 60;
    return mins == 1 ? '1 min' : '$mins min';
  }

  static String shortLabel(int seconds) {
    final s = snap(seconds);
    return '${s ~/ 60}m';
  }
}
