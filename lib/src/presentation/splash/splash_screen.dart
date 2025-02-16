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
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                PageContent(
                  title: "매일, 새로운 선택과 답변을 해주세요!\nAI가 당신만을 위한 번호를 알려드려요",
                  subtitle: "매일, 새로운 선택과 답변을 해주세요\nAI가 당신만을 위한 번호를 알려드려요",
                  image: Lottie.asset(
                    "assets/animations/splash_ai_lottie.json",
                    repeat: true,
                    fit: BoxFit.fill,
                    frameRate: FrameRate.max,
                  ),
                ),
                PageContent(
                  title: "추첨일이 다가오기 전에!\n최대한 많이 행운의 숫자를 생성하세요",
                  subtitle: "매주 토요일, 생성한 숫자를 활용해 도전해보세요\n단, 이 모든 것은 당신의 '행운'에 달려있습니다",
                  image: Lottie.asset(
                    "assets/animations/splash_luck_lottie.json",
                    repeat: true,
                    fit: BoxFit.fill,
                    frameRate: FrameRate.max,
                  ),
                ),
                PageContent(
                  title: "매일 진행되는 번호추천을 잊지 않도록\n반드시 알람설정을 허용해주세요",
                  subtitle: "하루 한번, 잊지 않도록 푸시 알림이 도착해요\n기회를 놓치지 않도록 도와드릴게요",
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
            backgroundColor: Theme.of(context).primaryColor,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  child: image,
                  width: 280,
                  height: 280,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
