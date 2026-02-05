import 'package:flutter/material.dart';
import '../../models/good_deed.dart';
import '../../services/good_deed_service.dart';
import 'widgets/good_deed_card.dart';
import 'widgets/level_progress_card.dart';
import 'widgets/add_good_deed_dialog.dart';

class GoodDeedPage extends StatefulWidget {
  const GoodDeedPage({super.key});

  @override
  State<GoodDeedPage> createState() => _GoodDeedPageState();
}

class _GoodDeedPageState extends State<GoodDeedPage> {
  late Future<List<GoodDeed>> _deedsFuture;
  late Future<Map<String, dynamic>> _levelInfoFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _deedsFuture = GoodDeedService.getTodayDeeds();
      _levelInfoFuture = GoodDeedService.getLevelInfo();
    });
  }

  void _toggleDeed(GoodDeed deed) async {
    final updated = deed.copyWith(isCompleted: !deed.isCompleted);
    await GoodDeedService.updateGoodDeed(updated);
    _loadData();
  }

  void _deleteDeed(String deedId) async {
    await GoodDeedService.deleteGoodDeed(deedId);
    _loadData();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddGoodDeedDialog(
        onAdd: (deed) {
          GoodDeedService.addGoodDeed(deed);
          _loadData();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebaikan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Level Progress Card
              FutureBuilder<Map<String, dynamic>>(
                future: _levelInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return LevelProgressCard(levelInfo: snapshot.data!);
                  }
                  return const SizedBox(height: 120);
                },
              ),
              const SizedBox(height: 20),

              // Header dengan Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hari Ini',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  FloatingActionButton.small(
                    onPressed: _showAddDialog,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List of Deeds for Today
              FutureBuilder<List<GoodDeed>>(
                future: _deedsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cs.surfaceContainer,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada kebaikan hari ini',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mulai dengan menambahkan kebaikan',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final deed = snapshot.data![index];
                      return GoodDeedCard(
                        deed: deed,
                        onToggle: () => _toggleDeed(deed),
                        onDelete: () => _deleteDeed(deed.id),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
