import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

/// App Colors
class AppColors {
  static const Color lightPrimary = Color(0xffD9534F);
  static const Color lightSecondary = Color(0xffF39C12);
  static const Color lightAccent = Color(0xff2ECC71);
  static const Color lightBackground = Color(0xffFFFFFF);
  static const Color lightBoxBackground = Color(0xffF8F8F8); // 기존 배경보다 약간 어두운 색
  static const Color lightActiveButton = Color(0xffD9534F);
  static const Color lightInactiveButton = Color(0xff333333);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xffD9534F);
  static const Color darkSecondary = Color(0xffE67E22);
  static const Color darkAccent = Color(0xff1ABC9C);
  static const Color darkBackground = Color(0xff1E1E1E);
  static const Color darkBoxBackground = Color(0xff252525); // 기존 배경보다 약간 밝은 색상
  static const Color darkActiveButton = Color(0xffC0392B);
  static const Color darkInactiveButton = Color(0xff333333);
}

/// BottomNavigationBar
class CustomBottomNavigationBar {
  static List<BottomNavigationBarItem> bottomNavigationBarItem = const [
    BottomNavigationBarItem(icon: Icon(UniconsLine.estate), label: '홈'),
    BottomNavigationBarItem(icon: Icon(UniconsLine.list_ol_alt), label: '번호보기'),
    BottomNavigationBarItem(icon: Icon(UniconsLine.user_circle), label: '마이페이지'),
  ];
}

/// WebView Routes
class WebRoutes {
  static const String homepage = 'https://momentous-wallet-0f7.notion.site/1681c3f0e003806c9b50dde42728413a?pvs=73';
  static const String termsOfUse = 'https://momentous-wallet-0f7.notion.site/1681c3f0e00380389faef7a3d636ce76?pvs=4';
  static const String privacyPolicy = 'https://momentous-wallet-0f7.notion.site/17b1c3f0e00380b5ae92ec994b5ccca8?pvs=4';
}

const dailyTipPlaceholder = "오늘의 작은 진전이 내일의 큰 차이를 만듭니다. 지속적으로 나아가면 결국에는 목표에 도달할 수 있어요";
const reasonPlaceholder = "빠른 결단을 나타내는 4번, 변화와 성장을 상징하는 11번과 29번, 기술적 혁신을 의미하는 18번과 23번을 선택했습니다.";