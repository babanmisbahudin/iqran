import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';
import 'widgets/onboarding_slide.dart';
import 'widgets/skip_button.dart';

class FirstTimeOnboardingPage extends StatefulWidget {
  const FirstTimeOnboardingPage({Key? key}) : super(key: key);

  @override
  State<FirstTimeOnboardingPage> createState() =>
      _FirstTimeOnboardingPageState();
}

class _FirstTimeOnboardingPageState extends State<FirstTimeOnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Assalamu\'alaikum! 👋',
      description:
          'Selamat datang di IQRAN. Aplikasi untuk mempermudah murajaah Al-Qur\'an harian Anda.',
      lottieAsset: 'assets/lottie/greeting.json',
    ),
    OnboardingSlideData(
      title: 'Fitur Unggulan',
      description:
          'Baca Al-Qur\'an dengan tajweed, simpan ayat favorit, pantau progress murajaah, dan dengarkan murottal berkualitas.',
      lottieAsset: 'assets/lottie/reading.json',
    ),
    OnboardingSlideData(
      title: 'Mulai Perjalanan Murajaah',
      description:
          'Mari konsisten membaca dan memahami Al-Qur\'an. Setiap hari adalah kesempatan untuk lebih dekat pada Kitab Allah.',
      lottieAsset: 'assets/lottie/praying.json',
      isLast: true,
    ),
  ];

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
      Navigator.of(context).pop();
    }
  }

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
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _currentPage == _slides.length - 1 ? 'Mulai Sekarang' : 'Lanjutkan',
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
