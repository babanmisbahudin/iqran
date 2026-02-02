import 'package:flutter/material.dart';

import '../../../models/doa.dart';

class DoaCard extends StatefulWidget {
  final Doa doa;

  const DoaCard({super.key, required this.doa});

  @override
  State<DoaCard> createState() => _DoaCardState();
}

class _DoaCardState extends State<DoaCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cs.surfaceContainer,
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              widget.doa.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              _isExpanded
                  ? Icons.expand_less
                  : Icons.expand_more,
              color: cs.primary,
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.doa.arabic.isNotEmpty) ...[
                    Text(
                      'Arab',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.doa.arabic,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.doa.latin.isNotEmpty) ...[
                    Text(
                      'Latin',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.doa.latin,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.doa.translation.isNotEmpty) ...[
                    Text(
                      'Terjemahan',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.doa.translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
