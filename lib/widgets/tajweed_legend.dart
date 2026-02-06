import 'package:flutter/material.dart';
import 'package:iqran/models/tajweed_rule.dart';

/// Widget untuk display legend semua tajweed rules
class TajweedLegend extends StatelessWidget {
  /// List of tajweed rules untuk di-display
  final List<TajweedRule> rules;

  /// Callback saat user tap rule
  final Function(TajweedRule)? onRuleTap;

  const TajweedLegend({
    Key? key,
    required this.rules,
    this.onRuleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cs.surface,
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tajweed Rules',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...rules.map((rule) => GestureDetector(
                onTap: () {
                  if (onRuleTap != null) {
                    onRuleTap!(rule);
                  } else {
                    _showRuleDetail(context, rule);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      // Color indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rule.color.withValues(alpha: 0.3),
                          border: Border.all(
                            color: rule.color,
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Rule info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  rule.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  rule.arabicName,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: rule.color,
                                      ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            Text(
                              rule.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Chevron
                      Icon(
                        Icons.chevron_right,
                        color: cs.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showRuleDetail(BuildContext context, TajweedRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rule.color.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  rule.name[0],
                  style: TextStyle(
                    color: rule.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rule.name),
                Text(
                  rule.arabicName,
                  style: TextStyle(color: rule.color),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(rule.fullDescription),
              const SizedBox(height: 16),
              Text(
                'Examples:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ...rule.examples.map((ex) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $ex'),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
