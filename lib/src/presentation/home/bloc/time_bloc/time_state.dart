import 'package:flutter/material.dart';
import '../../../../core/constants.dart';

enum TimePeriod { morning, lunch, evening }

class TimeState {
  final TimePeriod period;
  final String title;
  final String subtitle;
  final String date;
  final String imagePath;
  final Color background;

  TimeState({
    required this.period,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.imagePath,
    required this.background,
  });

  factory TimeState.fromPeriod(TimePeriod period, String date) {
    switch (period) {
      case TimePeriod.morning:
        return TimeState(
          period: period,
          title: "좋은 아침입니다️!",
          subtitle: "오늘도 멋진 하루를 시작하세요",
          date: date,
          imagePath: "assets/animations/morning_lottie.json",
          background: AppColors.lightPrimary,
        );
      case TimePeriod.lunch:
        return TimeState(
          period: period,
          title: "새로운 도전, 지금 시작!",
          subtitle: "목표를 향해 나아가세요",
          date: date,
          imagePath: "assets/animations/lunch_lottie.json",
          background: AppColors.lightSecondary,
        );
      case TimePeriod.evening:
        return TimeState(
          period: period,
          title: "편안한 저녁 되세요!",
          subtitle: "오늘 하루도 수고 많으셨습니다",
          date: date,
          imagePath: "assets/animations/evening_lottie.json",
          background: AppColors.darkTertiary,
        );
    }
  }
}