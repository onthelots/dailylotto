import 'package:dailylotto/src/presentation/home/notice_screen.dart';
import 'package:dailylotto/src/presentation/main/main_screen.dart';
import 'package:dailylotto/src/presentation/mypage/mypage_screen.dart';
import 'package:dailylotto/src/presentation/introduce/Introduce_screen.dart';
import 'package:dailylotto/src/presentation/mypage/notification_screen.dart';
import 'package:dailylotto/src/presentation/mypage/theme_screen.dart';
import 'package:dailylotto/src/presentation/question/ai_recommendation_screen.dart';
import 'package:dailylotto/src/presentation/weekly/round_list/all_round_screen.dart';
import 'package:dailylotto/src/presentation/weekly/weekly_screen.dart';
import 'package:flutter/material.dart';
import '../data/models/lotto_remote_model.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/latest_result/lastest_result_screen.dart';
import '../presentation/question/question_screen.dart';

class Routes {
  static const String splash = '/';
  static const String main = '/main'; // 메인

  // notice
  static const String notice = '/notice'; // 스플래시

  // splash
  static const String introduce = '/introduce'; // 스플래시

  // tab
  static const String home = '/home'; // 홈 (탭바)
  static const String weekly = '/weekly'; // 번호기록 (탭바)
  static const String mypage = '/mypage'; // 마임페이지 (탭바)

  // round list
  static const String allround = '/allround'; // 번호기록 (탭바)

  // latest round result
  static const String latestRoundResult = '/latestRoundResult'; // 최근 회차 결과

  static const String dailyQuestion = '/dailyQuestion'; // 번호 생성 퀴즈
  static const String recommendation = '/recommendation'; // 번호 생성 결과 (AI 추천결과)

  // settings
  static const String notification = '/notification'; // 알림 설정
  static const String theme = '/theme'; // 테마설정

}

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.notice:
        return MaterialPageRoute(
          builder: (_) => NoticeScreen(),
        );
      case Routes.weekly:
        return MaterialPageRoute(
          builder: (_) => WeeklyScreen(),
        );
      case Routes.mypage:
        return MaterialPageRoute(
          builder: (_) => MyPageScreen(),
        );
      case Routes.introduce:
        return MaterialPageRoute(
          builder: (_) => IntroduceScreen(),
        );
      case Routes.dailyQuestion:
        final currentRound = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => QuestionScreen(currentRound: currentRound),
        );
      case Routes.latestRoundResult:
        final latestRound = settings.arguments as LottoRemoteModel;
        return MaterialPageRoute(
          builder: (_) => LastestResultScreen(latestRound: latestRound),
        );
      case Routes.recommendation:
        return MaterialPageRoute(
          builder: (_) => AiRecommendationScreen(),
        );
      case Routes.allround:
        return MaterialPageRoute(
          builder: (_) => AllRoundsScreen(),
        );
      case Routes.notification:
        return MaterialPageRoute(
          builder: (_) => NotificationScreen(),
        );
      case Routes.theme:
        return MaterialPageRoute(
          builder: (_) => ThemeScreen(),
        );
      default:
        return null;
    }
  }
}
