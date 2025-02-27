import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/core/utils.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AiRecommendationScreen extends StatelessWidget {
  const AiRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LottoLocalBloc, LottoLocalState>(
      builder: (context, state) {
        if (state is LottoNumbersLoaded) {
          final todayEntry = state.todayEntry;

          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              scrolledUnderElevation: 0,
              leading: SizedBox.shrink(), // 기본 back 버튼 제거
              actions: [
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Lottie.asset(
                              "assets/animations/success_lottie.json",
                              repeat: false,
                              fit: BoxFit.fill,
                              frameRate: FrameRate.max,
                            ),
                          ),
                        ),

                        Text(
                          "오늘의 추천번호",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "(${todayEntry!.date})",
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          todayEntry!.numbers.join(", "),
                          style:
                              Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 28,
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: boxPadding),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: contentPaddingIntoBox,
                            vertical: contentPaddingIntoBox),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "추천 이유",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),

                              const SizedBox(height: 15),

                              Text(
                                todayEntry.recommendReason,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                    ),
                                maxLines: 3,
                              ),

                              const SizedBox(height: 30),

                              Text(
                                "Daily Tip",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                todayEntry.dailyTip,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                    ),
                                maxLines: 3,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
