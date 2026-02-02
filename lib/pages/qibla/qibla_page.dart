import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../models/qibla_direction.dart';
import '../../services/qibla_service.dart';
import '../../services/location_service.dart';
import 'widgets/compass_widget.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double _deviceHeading = 0.0;
  QiblaDirection? _qiblaDirection;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeQibla();
  }

  Future<void> _initializeQibla() async {
    try {
      // Get location
      final position = await LocationService.getCurrentPosition();

      if (mounted && position != null) {
        final qibla = QiblaService.getQiblaDirection(
          position.latitude,
          position.longitude,
        );

        setState(() {
          _qiblaDirection = qibla;
          _isLoading = false;
        });

        // Start compass stream
        FlutterCompass.events?.listen((CompassEvent event) {
          if (mounted) {
            setState(() {
              _deviceHeading = event.heading ?? 0.0;
            });
          }
        });
      } else if (mounted) {
        setState(() {
          _error = 'Lokasi tidak tersedia';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 48,
                        color: cs.error,
                      ),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _initializeQibla();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _qiblaDirection == null
                  ? const Center(child: Text('Menghitung arah kiblat...'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Compass
                            CompassWidget(
                              deviceHeading: _deviceHeading,
                              qiblaBearing: _qiblaDirection!.bearing,
                            ),
                            const SizedBox(height: 40),

                            // Info
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: cs.surfaceContainer,
                                border: Border.all(
                                  color: cs.outlineVariant,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: cs.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Lokasi',
                                              style: theme.textTheme.labelSmall,
                                            ),
                                            Text(
                                              '${_qiblaDirection!.userLatitude.toStringAsFixed(4)}° N, ${_qiblaDirection!.userLongitude.toStringAsFixed(4)}° E',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.straighten,
                                        color: cs.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Arah Kiblat',
                                              style: theme.textTheme.labelSmall,
                                            ),
                                            Text(
                                              '${_qiblaDirection!.bearing.toStringAsFixed(1)}° (${_qiblaDirection!.directionName})',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.near_me,
                                        color: cs.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Jarak ke Makkah',
                                              style: theme.textTheme.labelSmall,
                                            ),
                                            Text(
                                              _qiblaDirection!.formattedDistance,
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '⚠️ Pastikan kalibrasi kompas dengan gerakan 8 untuk hasil akurat',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
