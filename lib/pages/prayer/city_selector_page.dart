import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../../services/prayer_service.dart';

class CitySelector extends StatefulWidget {
  final Function(City) onCitySelected;

  const CitySelector({
    super.key,
    required this.onCitySelected,
  });

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  late Future<List<City>> _citiesFuture;
  List<City> _allCities = [];
  List<City> _filteredCities = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _citiesFuture = PrayerService.fetchCities();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _allCities;
      } else {
        final queryLower = query.toLowerCase();
        _filteredCities = _allCities
            .where((city) =>
                city.name.toLowerCase().contains(queryLower) ||
                city.province.toLowerCase().contains(queryLower))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kota'),
      ),
      body: FutureBuilder<List<City>>(
        future: _citiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _citiesFuture = PrayerService.fetchCities();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada kota tersedia'));
          }

          _allCities = snapshot.data!;
          _filteredCities = _allCities;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari kota...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _filterCities,
                ),
              ),
              Expanded(
                child: _filteredCities.isEmpty
                    ? const Center(child: Text('Kota tidak ditemukan'))
                    : ListView.builder(
                        itemCount: _filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = _filteredCities[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(city.name),
                            subtitle: Text(city.province),
                            onTap: () {
                              widget.onCitySelected(city);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
