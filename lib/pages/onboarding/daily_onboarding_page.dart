import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/onboarding_service.dart';
import '../../utils/hadith_data.dart';
import 'widgets/animated_character_card.dart';
import 'widgets/hadith_quote_card.dart';

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
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _hadith = getRandomHadith();
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
    final dayName = DateFormat('EEEE', 'id_ID').format(now);
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(now);

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
                        'Assalamu\'alaikum wa Rahmatullahi wa Barakatuh',
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
                    lottieAsset: 'assets/lottie/Reading in Quran.json',
                    fallbackImage:
                        'assets/images/onboarding/fallback_prayer.png',
                  ),
                ),
                const SizedBox(height: 32),
                // Hadith quote card
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
                      'Lanjutkan Bacaan',
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
