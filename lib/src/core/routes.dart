import 'package:dailylotto/src/presentation/home/notice_screen.dart';
import 'package:dailylotto/src/presentation/main/main_screen.dart';
import 'package:dailylotto/src/presentation/mypage/mypage_screen.dart';
import 'package:dailylotto/src/presentation/introduce/Introduce_screen.dart';
import 'package:dailylotto/src/presentation/mypage/notification_screen.dart';
import 'package:dailylotto/src/presentation/mypage/oss_license_screen.dart';
import 'package:dailylotto/src/presentation/mypage/theme_screen.dart';
import 'package:dailylotto/src/presentation/question/ai_recommendation_screen.dart';
import 'package:dailylotto/src/presentation/web/webview_screen.dart';
import 'package:dailylotto/src/presentation/weekly/round_list/all_round_screen.dart';
import 'package:dailylotto/src/presentation/weekly/weekly_screen.dart';
import 'package:flutter/material.dart';
import '../data/models/lotto_remote_model.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/latest_result/lastest_result_screen.dart';
import '../presentation/question/question_screen.dart';

/// Screen Routes
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
  static const String openSource = '/opensource'; // 오픈소스
  static const String webView = '/webView'; // 웹뷰
}

/// WebView Routes
class WebRoutes {
  static const String appSite= 'https://momentous-wallet-0f7.notion.site/1a81c3f0e003806980e5e8bd7732fa83?pvs=4'; // 앱 사이트
  static const String officialSite= 'https://dhlottery.co.kr/common.do?method=main'; // 동행복권 사이트
  static const String termsOfUse = 'https://momentous-wallet-0f7.notion.site/1ab1c3f0e0038007958ee9680d3a3256?pvs=4'; // 이용약관
  static const String privacyPolicy = 'https://momentous-wallet-0f7.notion.site/1ab1c3f0e003804a9e3ef0c151450022?pvs=4'; // 개인정보 보호
  static const String warning = 'https://momentous-wallet-0f7.notion.site/1ab1c3f0e0038032a81ec06504765a09?pvs=4'; // 주의사항
}


/// AppRouter
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
      case Routes.openSource:
        return MaterialPageRoute(
          builder: (_) => OssLicensesPage(),
        );
      case Routes.webView:
        final url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WebViewScreen(url: url),
        );
      default:
        return null;
    }
  }
}
