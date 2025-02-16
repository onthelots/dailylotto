import 'package:dailylotto/src/presentation/history/history_screen.dart';
import 'package:dailylotto/src/presentation/main/main_screen.dart';
import 'package:dailylotto/src/presentation/mypage/mypage_screen.dart';
import 'package:dailylotto/src/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/home/home_screen.dart';

class Routes {
  static const String splash = '/';
  static const String main = '/main'; // 메인

  // splash
  static const String splash_1 = '/sp1'; // 스플래시1
  static const String splash_2 = '/sp2'; // 스플래시2
  static const String splash_3 = '/sp3'; // 스플래시3

  // tab
  static const String home = '/home'; // 홈 (탭바)
  static const String history = '/history'; // 번호기록 (탭바)
  static const String mypage = '/mypage'; // 마임페이지 (탭바)

  // game
  static const String game_1 = '/g1'; // 게임 화면1
  static const String game_2 = '/g2'; // 게임 화면2
  static const String game_3 = '/g3'; // 게임 화면3
  static const String game_4 = '/g4'; // 게임 화면4
  static const String result = '/result'; // 게임 결과
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
      case Routes.history:
        return MaterialPageRoute(
          builder: (_) => HistoryScreen(),
        );
      case Routes.mypage:
        return MaterialPageRoute(
          builder: (_) => MyPageScreen(),
        );
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      default:
        return null;
    }
  }
}