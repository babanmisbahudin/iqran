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

class _DailyOnboardingPageState extends State<DailyOnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late HadithData _hadith;
  late int _autoCloseDuration;

  @override
  void initState() {
    super.initState();
    _hadith = getRandomHadith();
    _autoCloseDuration = 5; // seconds

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fade in animation
    _fadeController.forward();

    // Auto-dismiss after duration
    _scheduleAutoDismiss();
  }

  void _scheduleAutoDismiss() {
    Future.delayed(Duration(seconds: _autoCloseDuration), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    // Fade out
    await _fadeController.reverse();

    if (!mounted) return;

    // Mark as shown today
    await OnboardingService.markOnboardingShown();

    // Dismiss page
    if (mounted) {
      Navigator.of(context).pop();
      widget.onDismiss?.call();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE', 'id_ID').format(now);
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(now);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _dismiss();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FadeTransition(
          opacity: _fadeController,
          child: SafeArea(
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

                    // Animated character - reading quran with hadith
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lottie animation background
                        const SizedBox(
                          width: 280,
                          height: 280,
                          child: AnimatedCharacterCard(
                            lottieAsset: 'assets/lottie/Reading in Quran.json',
                            fallbackImage:
                                'assets/images/onboarding/fallback_prayer.png',
                          ),
                        ),
                        // Hadith quote overlay on animation
                        Positioned(
                          bottom: 20,
                          left: 16,
                          right: 16,
                          child: SizedBox(
                            width: double.infinity,
                            child: HadithQuoteCard(hadith: _hadith),
                          ),
                        ),
                      ],
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

                    const SizedBox(height: 16),

                    // Auto-close timer info
                    Text(
                      'Akan menutup otomatis dalam $_autoCloseDuration detik',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
