import 'package:flutter/material.dart';

import '../../models/prayer_time.dart';
import '../../models/city.dart';
import '../../services/prayer_service.dart';
import '../../services/city_storage_service.dart';
import 'city_selector_page.dart';
import 'widgets/prayer_time_card.dart';
import 'widgets/next_prayer_card.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  City? _selectedCity;
  PrayerTime? _todayPrayer;
  bool _isLoading = true;
  String? _error;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _loadSelectedCity();
  }

  Future<void> _loadSelectedCity() async {
    try {
      final city = await CityStorageService.getSelectedCity();

      if (mounted) {
        if (city != null) {
          setState(() => _selectedCity = city);
          await _loadPrayerTimes();
        } else {
          setState(() => _isLoading = false);
          if (mounted) {
            _showCitySelector();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading saved city: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPrayerTimes() async {
    if (_selectedCity == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final times = await PrayerService.fetchPrayerTimes(
        cityId: _selectedCity!.id,
        year: _currentDate.year,
        month: _currentDate.month,
      );

      if (mounted && times.isNotEmpty) {
        setState(() {
          _todayPrayer = times.firstWhere(
            (time) => time.date.contains(_currentDate.day.toString()),
            orElse: () => times.first,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading prayer times: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showCitySelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySelector(
          onCitySelected: (city) {
            setState(() => _selectedCity = city);
            CityStorageService.saveSelectedCity(city);
            _loadPrayerTimes();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: 'Ubah Kota',
            onPressed: _showCitySelector,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPrayerTimes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _selectedCity == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Pilih kota untuk melihat jadwal sholat'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _showCitySelector,
                            child: const Text('Pilih Kota'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City Info
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: cs.primary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedCity!.toString(),
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Next Prayer Card
                          if (_todayPrayer != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: NextPrayerCard(
                                prayerTime: _todayPrayer!,
                              ),
                            ),

                          // Prayer Times for Today
                          if (_todayPrayer != null) ...[
                            Text(
                              'Hari Ini',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            PrayerTimeCard(
                              name: 'Subuh',
                              time: _todayPrayer!.fajr,
                            ),
                            PrayerTimeCard(
                              name: 'Terbit',
                              time: _todayPrayer!.sunrise,
                            ),
                            PrayerTimeCard(
                              name: 'Dzuhur',
                              time: _todayPrayer!.dhuhr,
                            ),
                            PrayerTimeCard(
                              name: 'Ashar',
                              time: _todayPrayer!.asr,
                            ),
                            PrayerTimeCard(
                              name: 'Maghrib',
                              time: _todayPrayer!.maghrib,
                            ),
                            PrayerTimeCard(
                              name: 'Isya',
                              time: _todayPrayer!.isha,
                            ),
                          ],
                        ],
                      ),
                    ),
    );
  }
}
