import 'package:flutter/material.dart';

import 'fasting_tab.dart';
import 'doa_tab.dart';

class IbadahPage extends StatefulWidget {
  const IbadahPage({super.key});

  @override
  State<IbadahPage> createState() => _IbadahPageState();
}

class _IbadahPageState extends State<IbadahPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ibadah'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Puasa'),
            Tab(text: 'Doa'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FastingTab(
            key: PageStorageKey('fasting'),
          ),
          DoaTab(
            key: PageStorageKey('doa'),
          ),
        ],
      ),
    );
  }
}
