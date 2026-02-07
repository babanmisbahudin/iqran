import 'package:flutter/material.dart';

import 'audio_settings_card.dart';
import '../../widgets/developer_info_card.dart';
import '../../widgets/animated_card_wrapper.dart';

import '../../services/quran_preload_service.dart';
import '../../services/offline_status_service.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final double fontSize;
  final ValueChanged<bool> onTheme;
  final ValueChanged<double> onFont;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onTheme,
    required this.onFont,
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
        return SingleChildScrollView(
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
                                const SizedBox(height: 8),
                                Text(
                                  'Ukuran Font Arab: ${widget.fontSize.toInt()}',
                                ),
                                Slider(
                                  min: 20,
                                  max: 50,
                                  divisions: 10,
                                  value: widget.fontSize,
                                  onChanged: widget.onFont,
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

                      const SizedBox(height: 32),
                    ],
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
