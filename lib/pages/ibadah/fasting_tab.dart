import 'package:flutter/material.dart';

import '../../models/fasting_schedule.dart';
import '../../services/fasting_service.dart';
import '../../services/city_storage_service.dart';
import 'widgets/fasting_card.dart';

class FastingTab extends StatefulWidget {
  const FastingTab({super.key});

  @override
  State<FastingTab> createState() => _FastingTabState();
}

class _FastingTabState extends State<FastingTab> {
  List<FastingSchedule> _fastingList = [];
  final Map<String, bool> _tracker = {};

  @override
  void initState() {
    super.initState();
    _loadFastingData();
  }

  Future<void> _loadFastingData() async {
    final now = DateTime.now();
    final schedules = FastingService.getFastingByMonth(now.year, now.month);

    final tracker =
        await CityStorageService.getFastingTracker(now.year);

    if (mounted) {
      setState(() {
        _fastingList = schedules;
        _tracker.addAll(tracker);
      });
    }
  }

  Future<void> _toggleFasting(FastingSchedule schedule) async {
    final dateString = schedule.date.toString().split(' ')[0];
    final newState = !(_tracker[dateString] ?? false);

    await CityStorageService.updateFastingStatus(
      DateTime.now().year,
      schedule.date,
      newState,
    );

    setState(() {
      _tracker[dateString] = newState;
      schedule.isDone = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Puasa Sunnah ${months[now.month - 1]} ${now.year}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_fastingList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Tidak ada jadwal puasa bulan ini',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fastingList.length,
              itemBuilder: (context, index) {
                final fasting = _fastingList[index];
                final dateString = fasting.date.toString().split(' ')[0];
                final isDone = _tracker[dateString] ?? false;

                return FastingCard(
                  fasting: fasting,
                  isDone: isDone,
                  onToggle: () => _toggleFasting(fasting),
                );
              },
            ),
        ],
      ),
    );
  }
}
