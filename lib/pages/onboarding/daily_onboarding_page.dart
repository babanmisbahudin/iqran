import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/onboarding_service.dart';
import '../../utils/hadith_data.dart';
import '../../utils/doa_data.dart';
import 'widgets/animated_character_card.dart';
import 'widgets/hadith_quote_card.dart';
import 'widgets/dua_quote_card.dart';

class DailyOnboardingPage extends StatefulWidget {
  final VoidCallback? onDismiss;

  const DailyOnboardingPage({
    Key? key,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<DailyOnboardingPage> createState() => _DailyOnboardingPageState();
}

class _DailyOnboardingPageState extends State<DailyOnboardingPage> {
  late HadithData _hadith;
  DoaData? _doa;
  bool _isDismissing = false;
  bool _showDoa = false;

  @override
  void initState() {
    super.initState();
    _hadith = getRandomHadith();
    _loadRandomDoa();
  }

  Future<void> _loadRandomDoa() async {
    final doa = await getRandomDoa();
    if (doa != null && mounted) {
      setState(() {
        _doa = doa;
        // Randomly decide whether to show doa or hadith
        _showDoa = Random().nextBool();
      });
    }
  }

  void _dismiss() {
    // Prevent multiple dismissals
    if (_isDismissing) return;
    _isDismissing = true;

    // Call callback immediately to dismiss
    try {
      widget.onDismiss?.call();
    } catch (e) {
      // Silent error handling
    }

    // Mark as shown today in background (fire and forget)
    OnboardingService.markOnboardingShown().catchError((_) {
      // Silent error handling
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday % 7];
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = '${now.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'Selamat pagi',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$dayName, $dateStr',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pukul $timeStr',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Muhasabah diri sebelum memulai murajaah',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Animated character - reading quran
                const SizedBox(
                  width: 280,
                  height: 280,
                  child: AnimatedCharacterCard(
                    lottieAsset: 'assets/lottie/Hadist.json',
                    fallbackImage:
                        'assets/images/onboarding/fallback_prayer.png',
                  ),
                ),
                const SizedBox(height: 32),
                // Hadith or Doa quote card
                if (_showDoa && _doa != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DuaQuoteCard(doa: _doa!),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HadithQuoteCard(hadith: _hadith),
                  ),
                const SizedBox(height: 48),
                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _dismiss,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue Reading',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
