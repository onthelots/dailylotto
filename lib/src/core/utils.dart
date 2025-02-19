import 'package:flutter/material.dart';
import 'constants.dart';

class LottoUtils {
  // 로또 번호 색상 반환
  static Color getLottoBallColor(int number) {
    if (number <= 10) {
      return AppColors.lightSecondary; // lightSecondary: 더 부드러운 노란색 느낌
    } else if (number <= 20) {
      return AppColors.darkAccent; // darkAccent: 좀 더 고급스러운 파란색
    } else if (number <= 30) {
      return AppColors.darkPrimary; // darkPrimary: 차분한 빨간색
    } else if (number <= 40) {
      return AppColors.lightPrimary; // lightPrimary: 따뜻한 회색 톤
    } else {
      return AppColors.lightAccent; // lightAccent: 부드러운 초록색
    }
  }

  // 로또 공 UI 위젯 반환
  static Widget lottoBall(int number) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getLottoBallColor(number),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
