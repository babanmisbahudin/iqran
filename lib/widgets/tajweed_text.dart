import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:iqran/models/tajweed_segment.dart';
import 'package:iqran/services/tajweed_service.dart';

/// Widget untuk display Arabic text dengan tajweed highlighting
class TajweedText extends StatelessWidget {
  /// Arabic text untuk di-highlight
  final String arabicText;

  /// List of tajweed segments (jika sudah di-detect)
  /// Jika null, akan di-detect otomatis
  final List<TajweedSegment>? segments;

  /// Text style untuk base text
  final TextStyle? style;

  /// Text align
  final TextAlign textAlign;

  /// Callback saat user tap highlighted text
  final Function(TajweedSegment)? onTajweedTap;

  const TajweedText(
    this.arabicText, {
    Key? key,
    this.segments,
    this.style,
    this.textAlign = TextAlign.right,
    this.onTajweedTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.8,
        ) ??
        const TextStyle();

    // Detect tajweed jika belum ada segments
    final detectedSegments = segments ?? TajweedService.detectTajweed(arabicText);

    if (detectedSegments.isEmpty) {
      // Jika tidak ada tajweed, display plain text
      return Text(
        arabicText,
        style: baseStyle,
        textAlign: textAlign,
        textDirection: TextDirection.rtl,
      );
    }

    // Create spans dengan highlighting
    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final segment in detectedSegments) {
      // Add text sebelum segment
      if (segment.startIndex > lastIndex) {
        spans.add(
          TextSpan(
            text: arabicText.substring(lastIndex, segment.startIndex),
            style: baseStyle,
          ),
        );
      }

      // Add highlighted segment dengan GestureRecognizer
      spans.add(
        TextSpan(
          text: segment.text,
          style: baseStyle.copyWith(
            backgroundColor: segment.rule.color.withValues(alpha: 0.3),
            color: segment.rule.color,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onTajweedTap != null) {
                onTajweedTap!(segment);
              } else {
                // Show default dialog dengan rule info
                _showRuleDialog(context, segment);
              }
            },
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

    return RichText(
      text: TextSpan(children: spans),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
    );
  }

  void _showRuleDialog(BuildContext context, TajweedSegment segment) {
    final rule = segment.rule;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rule.color.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        segment.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          rule.arabicName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: rule.color,
                                fontWeight: FontWeight.bold,
                              ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                rule.fullDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Examples
              Text(
                'Contoh:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...rule.examples.map((example) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '• $example',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
