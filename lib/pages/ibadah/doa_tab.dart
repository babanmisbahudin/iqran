import 'package:flutter/material.dart';

import '../../models/doa.dart';
import '../../services/doa_service.dart';
import 'widgets/doa_card.dart';

class DoaTab extends StatefulWidget {
  const DoaTab({super.key});

  @override
  State<DoaTab> createState() => _DoaTabState();
}

class _DoaTabState extends State<DoaTab> {
  late Future<List<Doa>> _doasFuture;
  final _searchController = TextEditingController();
  List<Doa> _allDoas = [];
  List<Doa> _filteredDoas = [];

  @override
  void initState() {
    super.initState();
    _doasFuture = DoaService.fetchAllDoas();
  }

  void _filterDoas(String query) {
    if (query.isEmpty) {
      setState(() => _filteredDoas = _allDoas);
    } else {
      final queryLower = query.toLowerCase();
      setState(() {
        _filteredDoas = _allDoas
            .where((doa) =>
                doa.title.toLowerCase().contains(queryLower) ||
                doa.translation.toLowerCase().contains(queryLower))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doa>>(
      future: _doasFuture,
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
                      _doasFuture = DoaService.fetchAllDoas();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada doa tersedia'));
        }

        _allDoas = snapshot.data!;
        _filteredDoas = _allDoas;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari doa...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _filterDoas,
              ),
            ),
            Expanded(
              child: _filteredDoas.isEmpty
                  ? const Center(child: Text('Doa tidak ditemukan'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredDoas.length,
                      itemBuilder: (context, index) {
                        final doa = _filteredDoas[index];
                        return DoaCard(doa: doa);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
