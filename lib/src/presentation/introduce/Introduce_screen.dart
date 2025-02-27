import 'package:dailylotto/src/core/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_pageController.page! < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      SharedPreferencesHelper.setFirstRunStateToFalse(); // 첫 구동 false로 설정
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (route) => false); // 다음 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PageView(
                controller: _pageController,
                children: [
                  PageContent(
                    title: "AI를 활용하여 로또 번호를 추천해드려요",
                    subtitle: "매일 단 한번의 기회를 놓치지 마시고,\n당신만의 행운의 숫자를 만나보세요!",
                    image: Lottie.asset(
                      "assets/animations/splash_ai_lottie.json",
                      repeat: true,
                      fit: BoxFit.fill,
                      frameRate: FrameRate.max,
                    ),
                  ),
                  PageContent(
                    title: "아직까지 랜덤 생성 번호를 사용하나요?",
                    subtitle: "이제, 당신의 행운을 시험해보세요!\n어느새 매주 추첨일이 기다려질거에요",
                    image: Lottie.asset(
                      "assets/animations/splash_luck_lottie.json",
                      repeat: true,
                      fit: BoxFit.fill,
                      frameRate: FrameRate.max,
                    ),
                  ),
                  PageContent(
                    title: "서비스 이용을 위해 알림을 허용해주세요",
                    subtitle: "혹시, 오늘 번호 생성을 잊으셨나요?\n하루 한번, PUSH 알림을 보내드릴게요",
                    image: Lottie.asset(
                      "assets/animations/splash_alert_lottie.json",
                      repeat: true,
                      fit: BoxFit.fill,
                      frameRate: FrameRate.max,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 인디케이터 위치 조정
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppColors.lightPrimary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        child: ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            "다음",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget image;
  PageContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // 화면 크기 가져오기
    final double imageSize = size.width * 0.7; // 화면 너비의 70%를 이미지 크기로 설정
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            Center(
              child: SizedBox(
                child: image,
                width: imageSize,
                height: imageSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
