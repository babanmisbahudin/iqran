import 'package:flutter/material.dart';

import 'doa_tab.dart';

class IbadahPage extends StatelessWidget {
  const IbadahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa'),
      ),
      body: const DoaTab(
        key: PageStorageKey('doa'),
      ),
    );
  }
}
