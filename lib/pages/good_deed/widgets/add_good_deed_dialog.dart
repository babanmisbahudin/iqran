import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/good_deed.dart';
import '../../../services/good_deed_service.dart';

class AddGoodDeedDialog extends StatefulWidget {
  final Function(GoodDeed) onAdd;

  const AddGoodDeedDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddGoodDeedDialog> createState() => _AddGoodDeedDialogState();
}

class _AddGoodDeedDialogState extends State<AddGoodDeedDialog> {
  final _titleController = TextEditingController();
  String _selectedCategory = 'puasa';
  bool _isCompleted = false;

  final categories = [
    ('puasa', 'Puasa'),
    ('infaq', 'Infaq'),
    ('tilawah', 'Tilawah'),
    ('dzikir', 'Dzikir'),
    ('sedekah', 'Sedekah'),
    ('berbuat_baik', 'Berbuat Baik'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  int _getExpForCategory(String category) {
    final exp = GoodDeedService.defaultDeeds[category];
    return exp != null ? exp['exp'] as int : 25;
  }

  void _addDeed() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama kebaikan')),
      );
      return;
    }

    final deed = GoodDeed(
      id: const Uuid().v4(),
      title: _titleController.text,
      category: _selectedCategory,
      expPoints: _getExpForCategory(_selectedCategory),
      date: DateTime.now(),
      isCompleted: _isCompleted,
      isCustom: true,
    );

    widget.onAdd(deed);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final exp = _getExpForCategory(_selectedCategory);

    return AlertDialog(
      title: const Text('Tambah Kebaikan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Nama kebaikan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            Text(
              'Kategori',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat.$1,
                        child: Text(cat.$2),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // EXP Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: cs.primary.withValues(alpha: 0.1),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '+$exp EXP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Completed Checkbox
            CheckboxListTile(
              value: _isCompleted,
              onChanged: (value) {
                setState(() => _isCompleted = value ?? false);
              },
              title: const Text('Tandai sebagai selesai'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _addDeed,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
