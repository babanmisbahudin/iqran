import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio_settings_card.dart';
import '../../widgets/developer_info_card.dart';
import '../../widgets/animated_card_wrapper.dart';

import '../../services/quran_preload_service.dart';
import '../../services/offline_status_service.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final double fontSize;
  final double latinFontSize;
  final ValueChanged<bool> onTheme;
  final ValueChanged<double> onFont;
  final ValueChanged<double> onLatinFont;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.latinFontSize,
    required this.onTheme,
    required this.onFont,
    required this.onLatinFont,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDownloading = false;
  bool _offlineReady = false;

  int _current = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _loadOfflineStatus();
  }

  Future<void> _loadOfflineStatus() async {
    final ready = await OfflineStatusService.isReady();
    if (mounted) {
      setState(() => _offlineReady = ready);
    }
  }

  Future<void> _onRefresh() async {
    await _loadOfflineStatus();
  }

  Future<void> _startOfflineDownload() async {
    setState(() {
      _isDownloading = true;
      _current = 0;
      _total = 0;
    });

    try {
      await QuranPreloadService.preloadAll(
        onProgress: (current, total) {
          if (!mounted) return;
          setState(() {
            _current = current;
            _total = total;
          });
        },
      );

      if (!mounted) return;

      setState(() {
        _offlineReady = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Al-Qur’an siap digunakan secara offline'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengunduh data offline'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // =========================
                      // TAMPILAN
                      // =========================
                      AnimatedCardWrapper(
                        entranceDelay: const Duration(milliseconds: 100),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tampilan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Light/Dark Mode'),
                                  subtitle: const Text(
                                    'Aktifkan mode terang atau gelap',
                                  ),
                                  value: widget.isDark,
                                  onChanged: widget.onTheme,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Ukuran Font Arab: ${widget.fontSize.toInt()}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Slider(
                                  min: 20,
                                  max: 50,
                                  divisions: 10,
                                  value: widget.fontSize,
                                  onChanged: widget.onFont,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Ukuran Font Latin: ${widget.latinFontSize.toInt()}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Slider(
                                  min: 12,
                                  max: 24,
                                  divisions: 12,
                                  value: widget.latinFontSize,
                                  onChanged: widget.onLatinFont,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // OFFLINE MODE (UX FIX)
                      // =========================
                      AnimatedCardWrapper(
                        entranceDelay: const Duration(milliseconds: 200),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Offline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                if (_offlineReady) ...[
                                  const Text(
                                    '✅ Al-Qur\'an sudah siap digunakan secara offline.',
                                  ),
                                ] else if (_isDownloading) ...[
                                  LinearProgressIndicator(
                                    value: _total == 0 ? null : _current / _total,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Mengunduh $_current / $_total surah'),
                                ] else ...[
                                  const Text(
                                    'Unduh seluruh surah agar aplikasi tetap bisa '
                                    'digunakan tanpa koneksi internet.',
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.download),
                                      label: const Text('Download semua surah'),
                                      onPressed: _startOfflineDownload,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // AUDIO MUROTTAL
                      // =========================
                      const AnimatedCardWrapper(
                        entranceDelay: Duration(milliseconds: 300),
                        child: AudioSettingsCard(),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // DEVELOPER & COPYRIGHT
                      // =========================
                      const AnimatedCardWrapper(
                        entranceDelay: Duration(milliseconds: 400),
                        child: DeveloperInfoCard(),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // SUPPORTERS
                      // =========================
                      AnimatedCardWrapper(
                        entranceDelay: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 24,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Dukungan',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Terima kasih kepada para pendukung aplikasi iQran:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 16,
                                  headingRowHeight: 40,
                                  dataRowMinHeight: 40,
                                  dataRowMaxHeight: 40,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'No',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Nama Pendukung',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Instagram',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: [
                                        DataCell(Text(
                                          '1',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )),
                                        DataCell(Text(
                                          'Bisaproduktif',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )),
                                        DataCell(
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(const ClipboardData(text: '@bisaproduktif_'));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('@bisaproduktif_ disalin'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '@bisaproduktif_',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text(
                                          '2',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )),
                                        DataCell(Text(
                                          'Muh Fajar Shidik CH',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )),
                                        DataCell(
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(const ClipboardData(text: '@fajar_shidikch'));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('@fajar_shidikch disalin'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '@fajar_shidikch',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
            ),
          );
        },
      );
    }
  }

// Language selection button widget
