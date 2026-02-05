import 'package:flutter/material.dart';
import '../../../models/good_deed.dart';

class GoodDeedCard extends StatelessWidget {
  final GoodDeed deed;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const GoodDeedCard({
    super.key,
    required this.deed,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(deed.category, cs);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cs.surfaceContainer,
        border: Border.all(
          color: cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: deed.isCompleted,
              onChanged: (_) => onToggle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),

            // Title dan Category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deed.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          decoration: deed.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: categoryColor.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          deed.category,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${deed.expPoints} EXP',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              icon: Icon(Icons.close, size: 18, color: cs.onSurfaceVariant),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, ColorScheme cs) {
    switch (category) {
      case 'puasa':
        return Colors.pink;
      case 'infaq':
        return Colors.orange;
      case 'tilawah':
        return Colors.green;
      case 'dzikir':
        return Colors.blue;
      case 'sedekah':
        return Colors.purple;
      case 'berbuat_baik':
        return Colors.cyan;
      default:
        return cs.primary;
    }
  }
}
