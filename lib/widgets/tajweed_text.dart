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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeTextColor = theme.textTheme.bodyLarge?.color;

    // Merge provided style with theme colors
    final baseStyle = (style ?? const TextStyle()).copyWith(
      color: style?.color ?? themeTextColor,
      height: style?.height ?? 1.8,
    );

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
      // Adjust colors based on theme brightness for better contrast
      final Color textColor = isDark
          ? segment.rule.color // Keep original bright color for dark mode
          : Color.lerp(segment.rule.color, Colors.black, 0.4) ??
              segment.rule.color; // Darken for light mode

      spans.add(
        TextSpan(
          text: segment.text,
          style: baseStyle.copyWith(
            backgroundColor: segment.rule.color.withValues(alpha: 0.2),
            color: textColor,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Hero Section - Colored Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          rule.color.withValues(alpha: 0.1),
                          rule.color.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: rule.color.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: rule.color.withValues(alpha: 0.2),
                            border: Border.all(
                              color: rule.color.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              segment.text,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: rule.color,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rule.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                rule.arabicName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: rule.color,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  Text(
                    'Penjelasan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    rule.fullDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Examples Section
                  Text(
                    'Contoh Penerapan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...rule.examples.asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    String example = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: rule.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: rule.color.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: rule.color.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$idx',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: rule.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                example,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
