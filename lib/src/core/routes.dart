import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/presentation/main/main_screen.dart';
import 'package:dailylotto/src/presentation/mypage/mypage_screen.dart';
import 'package:dailylotto/src/presentation/introduce/Introduce_screen.dart';
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

  // splash
  static const String introduce = '/introduce'; // 스플래시1

  // tab
  static const String home = '/home'; // 홈 (탭바)
  static const String weekly = '/weekly'; // 번호기록 (탭바)
  static const String mypage = '/mypage'; // 마임페이지 (탭바)

  // round list
  static const String allround = '/allround'; // 번호기록 (탭바)

  // latest round result
  static const String latestRoundResult = '/latestRoundResult'; // 최근 회차 결과

  // game
  static const String game_1 = '/g1'; // 게임 화면1
  static const String game_2 = '/g2'; // 게임 화면2
  static const String game_3 = '/g3'; // 게임 화면3
  static const String game_4 = '/g4'; // 게임 화면4
  static const String result = '/result'; // 게임 결과

  static const String dailyQuestion = '/dailyQuestion'; // 번호 생성 퀴즈
  static const String recommendation = '/recommendation'; // 번호 생성 결과
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
      default:
        return null;
    }
  }
}