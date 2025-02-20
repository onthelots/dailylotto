import 'package:flutter/material.dart';
import 'constants.dart';

class LottoUtils {
  // 로또 번호 색상 반환
  static Color getLottoBallColor(int number) {
    if (number <= 10) {
      return Color(0xFFFFB81C); // 어두운 노란색 (RGB: 255, 184, 28)
    } else if (number <= 20) {
      return Color(0xFF3578E5); // 선명한 파란색 (RGB: 53, 120, 229)
    } else if (number <= 30) {
      return Color(0xFFEF4343); // 선명한 빨간색 (RGB: 239, 67, 67)
    } else if (number <= 40) {
      return Color(0xFF9E9E9E); // 부드러운 회색 (RGB: 158, 158, 158)
    } else {
      return Color(0xFF388E3C); // 선명한 초록색 (RGB: 56, 142, 60)
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
