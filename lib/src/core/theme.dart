import 'package:flutter/material.dart';
import 'constants.dart';

/// AppTheme
class AppTheme {

  // Light_Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary, // 주요색상
    focusColor: AppColors.lightAccent,
    scaffoldBackgroundColor: AppColors.lightBackground, // 백그라운드 색상
    highlightColor: AppColors.lightAccent,

    // - text
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black87, fontSize: 32),
      displayMedium: TextStyle(color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
      bodySmall: TextStyle(color: Colors.black54, fontSize: 13),
      labelLarge: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold), // 버튼 라벨 텍스트 크기 (카테고리)
      labelMedium: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w800), // Section 타이틀
      labelSmall: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600), // 위치, 장소
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground, // 탭바 배경색
      selectedItemColor: AppColors.lightActiveButton, // 선택된 아이콘 색
      unselectedItemColor: AppColors.lightInactiveButton, // 선택되지 않은 아이콘 색
      showUnselectedLabels: true, // 비선택된 아이템에 텍스트도 보이게

      selectedLabelStyle: TextStyle(
        color: AppColors.lightActiveButton, // 선택된 텍스트 색상
      ),

      unselectedLabelStyle: TextStyle(
        color: AppColors.lightInactiveButton, // 비선택된 텍스트 색상
      ),
    ),
  );


  // Dark_Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    focusColor: AppColors.darkAccent,
    scaffoldBackgroundColor: AppColors.darkBackground,
    highlightColor: AppColors.darkAccent,

    // - text
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 32),
      displayMedium: TextStyle(color: Colors.white70, fontSize: 25, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      bodySmall: TextStyle(color: Colors.white70, fontSize: 13),
      labelLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // 버튼 라벨 텍스트 크기 (카테고리)
      labelMedium: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w800), // Section 타이틀
      labelSmall: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600), // 위치, 장소
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground, // 탭바 배경색
      selectedItemColor: AppColors.darkActiveButton, // 선택된 아이콘 색
      unselectedItemColor: AppColors.darkInactiveButton, // 선택되지 않은 아이콘 색
      showUnselectedLabels: true, // 비선택된 아이템에 텍스트도 보이게
      selectedLabelStyle: TextStyle(
        color: AppColors.darkActiveButton, // 선택된 텍스트 색상
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColors.darkInactiveButton, // 비선택된 텍스트 색상
      ),
    ),
  );
}