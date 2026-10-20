class SortableItem {
  const SortableItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.categoryId,
    this.voiceName,
    this.accentColor,
    this.visualScale = 1.0,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String emoji;
  final String categoryId;

  /// Spoken label (e.g. "Red!"); falls back to [name].
  final String? voiceName;

  /// Optional tint for the floating chip (used by Color Sort notebooks).
  final int? accentColor;

  /// Relative chip size (e.g. big vs small objects).
  final double visualScale;

  /// Transparent PNG drawn inside the floating bubble. Emoji is the fallback.
  final String? imageAsset;

  String get spokenName => voiceName ?? name;
}
