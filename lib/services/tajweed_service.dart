import 'package:flutter/material.dart';
import 'package:iqran/models/tajweed_rule.dart';
import 'package:iqran/models/tajweed_segment.dart';

/// Service untuk handle tajweed detection dan highlighting
class TajweedService {
  /// Cache for loaded rules
  static final Map<String, TajweedRule> _rulesCache = {};

  /// Initialize rules dari default
  static void initialize() {
    final rules = TajweedRule.getDefaultRules();
    for (final rule in rules) {
      _rulesCache[rule.id] = rule;
    }
  }

  /// Get all available rules
  static List<TajweedRule> getAllRules() {
    if (_rulesCache.isEmpty) {
      initialize();
    }
    return _rulesCache.values.toList();
  }

  /// Get rule by ID
  static TajweedRule? getRule(String ruleId) {
    if (_rulesCache.isEmpty) {
      initialize();
    }
    return _rulesCache[ruleId];
  }

  /// Detect tajweed dalam teks Arab
  /// Returns list of segments dengan tajweed yang terdeteksi
  static List<TajweedSegment> detectTajweed(String arabicText) {
    if (_rulesCache.isEmpty) {
      initialize();
    }

    final segments = <TajweedSegment>[];
    final rules = _rulesCache.values.toList();

    // Untuk setiap character dalam text, check apakah cocok dengan pattern
    for (int i = 0; i < arabicText.length; i++) {
      final char = arabicText[i];

      for (final rule in rules) {
        // Simple pattern matching - check apakah character ada dalam patterns
        if (rule.patterns.contains(char)) {
          // Check apakah sudah ada segment yang overlap
          bool hasOverlap = segments.any((s) =>
              s.startIndex <= i && i <= s.endIndex);

          if (!hasOverlap) {
            segments.add(
              TajweedSegment(
                text: char,
                ruleId: rule.id,
                startIndex: i,
                endIndex: i,
                rule: rule,
              ),
            );
          }
        }
      }
    }

    // Sort by start index
    segments.sort((a, b) => a.startIndex.compareTo(b.startIndex));

    return segments;
  }

  /// Convert detected segments ke TextSpan list untuk RichText
  static List<TextSpan> highlightText(
    String arabicText,
    List<TajweedSegment> segments,
    TextStyle baseStyle,
  ) {
    if (segments.isEmpty) {
      return [TextSpan(text: arabicText, style: baseStyle)];
    }

    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final segment in segments) {
      // Add text sebelum segment
      if (segment.startIndex > lastIndex) {
        spans.add(
          TextSpan(
            text: arabicText.substring(lastIndex, segment.startIndex),
            style: baseStyle,
          ),
        );
      }

      // Add highlighted segment
      spans.add(
        TextSpan(
          text: segment.text,
          style: baseStyle.copyWith(
            backgroundColor: segment.rule.color.withValues(alpha: 0.3),
            color: segment.rule.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastIndex = segment.endIndex + 1;
    }

    // Add remaining text
    if (lastIndex < arabicText.length) {
      spans.add(
        TextSpan(
          text: arabicText.substring(lastIndex),
          style: baseStyle,
        ),
      );
    }

    return spans;
  }
}
