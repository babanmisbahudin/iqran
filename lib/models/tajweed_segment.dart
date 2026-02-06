import 'tajweed_rule.dart';

/// Represent a segment of text dengan tajweed rule yang diterapkan
class TajweedSegment {
  /// Text yang akan di-highlight
  final String text;

  /// Rule ID yang diterapkan
  final String ruleId;

  /// Start index dalam original text
  final int startIndex;

  /// End index dalam original text
  final int endIndex;

  /// Reference ke TajweedRule untuk warna dan info
  final TajweedRule rule;

  TajweedSegment({
    required this.text,
    required this.ruleId,
    required this.startIndex,
    required this.endIndex,
    required this.rule,
  });

  @override
  String toString() =>
      'TajweedSegment(text: $text, rule: $ruleId, range: $startIndex-$endIndex)';
}
