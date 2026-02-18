import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';
import 'widgets/onboarding_slide.dart';
import 'widgets/skip_button.dart';

class FirstTimeOnboardingPage extends StatefulWidget {
  final VoidCallback? onComplete;

  const FirstTimeOnboardingPage({
    Key? key,
    this.onComplete,
  }) : super(key: key);

  @override
  State<FirstTimeOnboardingPage> createState() =>
      _FirstTimeOnboardingPageState();
}

class _FirstTimeOnboardingPageState extends State<FirstTimeOnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  List<OnboardingSlideData> _buildSlides(BuildContext context) {
    return [
      OnboardingSlideData(
        title: 'Baca Al-Qur\'an',
        description: 'Jelajahi Al-Qur\'an yang suci dengan murotal dan terjemahan yang indah',
        lottieAsset: 'assets/lottie/Reading Quran.json',
      ),
      OnboardingSlideData(
        title: 'Berbagi dengan Keluarga',
        description: 'Belajar bersama orang-orang terkasih dan berkembang secara spiritual',
        lottieAsset:
            'assets/lottie/Muslim Father and Daughter Reading Koran.json',
      ),
      OnboardingSlideData(
        title: 'Pengingat Harian',
        description: 'Dapatkan inspirasi dengan hadis dan ayat-ayat setiap hari',
        lottieAsset: 'assets/lottie/Koran im Ramadan lesen.json',
      ),
      OnboardingSlideData(
        title: 'Mulai Perjalananmu',
        description: 'Mulai perjalanan belajar Al-Qur\'an Anda hari ini',
        lottieAsset: 'assets/lottie/Reading in Quran.json',
        isLast: true,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onSkip() async {
    await OnboardingService.completeFirstLaunch();
    await OnboardingService.markOnboardingShown();
    if (mounted) {
      widget.onComplete?.call();
    }
  }

  late List<OnboardingSlideData> _slides;

  Future<void> _onContinue() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Last slide - complete onboarding
      await OnboardingService.completeFirstLaunch();
      await OnboardingService.markOnboardingShown();

      if (mounted) {
        // Navigate back to main app
        widget.onComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _slides = _buildSlides(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),
        actions: [
          if (_currentPage < _slides.length - 1)
            SkipButton(
              onPressed: _onSkip,
              visible: !_slides[_currentPage].isLast,
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: _slides.length,
        itemBuilder: (context, index) => OnboardingSlide(
          title: _slides[index].title,
          description: _slides[index].description,
          lottieAsset: _slides[index].lottieAsset,
          imageAsset: _slides[index].imageAsset,
          isLast: _slides[index].isLast,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue button
            ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage == _slides.length - 1
                    ? 'Mulai Sekarang'
                    : 'Lanjutkan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final String? lottieAsset;
  final String? imageAsset;
  final bool isLast;

  OnboardingSlideData({
    required this.title,
    required this.description,
    this.lottieAsset,
    this.imageAsset,
    this.isLast = false,
  });
}
