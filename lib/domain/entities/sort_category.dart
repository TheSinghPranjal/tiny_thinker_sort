class SortCategory {
  const SortCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    this.zoneStyle = 'basket',
    this.caption,
  });

  final String id;
  final String label;
  final String emoji;
  final int color;

  /// How the drop zone is drawn: `basket`, `house`, or `jungle`.
  final String zoneStyle;

  /// Short line under the zone label, e.g. "Cosy house".
  final String? caption;
}
