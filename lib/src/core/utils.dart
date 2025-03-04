import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // 로또 공 UI 위젯
  static Widget lottoBall({required int number, required double width, required double height}) {
    return Container(
      width: width,
      height: height,
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
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 일정한 배경색
  static Widget lottoSolidBall({
    required Color color,
    required int number,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: number == -1 ? Colors.grey : AppColors.lightAccent,
      ),
      alignment: Alignment.center,
      child: Text(
        number == -1 ? "?" : number.toString(), // -1이면 '?'로 표시
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  // 로또 숫자 UI 위젯 (배경 없음)
  static Widget lottoNumber({
    required int number,
    required bool isCorrect,
  }) {
    return SizedBox(
      width: 30, // ✅ 모든 숫자의 너비를 동일하게 설정
      child: Text(
        number.toString(),
        style: TextStyle(
          color: isCorrect ? AppColors.lightAccent : null,
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
        ),
        textAlign: TextAlign.center, // ✅ 텍스트를 가운데 정렬
      ),
    );
  }


  // 1인당 당첨금액 반올림 (억/만 단위)
  static String formatPrizeAmount(int amount) {
    if (amount >= 100000000) {
      return "약 ${(amount / 100000000).round()}억 원"; // 1억 단위로 반올림
    } else if (amount >= 10000) {
      return "약 ${(amount / 10000).round()}만 원"; // 1만 단위로 반올림
    }
    return "$amount원"; // 1만 원 미만은 그대로 출력
  }

  // timestamp to 년-월-일
  static String formattedTimestamp(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
