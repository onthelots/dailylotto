import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/data/models/recommendation_args.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AiRecommendationScreen extends StatefulWidget {
  final RecommendationArgs recommendationArgs;
  const AiRecommendationScreen({super.key, required this.recommendationArgs});

  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LottoLocalBloc>().add(LoadLottoNumbersEvent(recommendationArgs: widget.recommendationArgs));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<LottoLocalBloc, LottoLocalState>(
        builder: (context, state) {
          if (state is LottoNumbersLoaded) {
            final selectEntry = state.selectEntry;

            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                toolbarHeight: 70,
                backgroundColor: Theme.of(context).primaryColor,
                scrolledUnderElevation: 0,
                title: Column(
                  children: [
                    Text(
                      "${selectEntry!.date}",
                      style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.recommendationArgs.round}회",
                      style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                leading: SizedBox.shrink(), // 기본 back 버튼 제거
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        widget.recommendationArgs.popUntil ? Navigator.popUntil(context, (route) => route.isFirst) : Navigator.pop(context);
                      },
                    ),
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

                          Center(
                            child: Text(
                              "오늘의 추천번호",
                              style:
                                  Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Center(
                            child: Text(
                              selectEntry.numbers.join(", "),
                              style:
                                  Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontSize: 28,
                                        color: Colors.white70,
                                      ),
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
                                  selectEntry.recommendReason,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
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
                                  selectEntry.dailyTip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
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
      ),
    );
  }
}
