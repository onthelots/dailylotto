import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeTitleDisplay extends StatelessWidget {
  const HomeTitleDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // <----- 타이틀 ---->
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.title,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium?.copyWith(color: Colors.white),
                    ),

                    SizedBox(
                      height: 3,
                    ),

                    Text(
                      state.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium?.copyWith(color: Colors.white),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      state.date,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),

                Spacer(),

                // <----- Lottie 이미지 ---->
                SizedBox(
                  width: 130,
                  height: 130,
                  child: BlocBuilder<TimeBloc, TimeState>(
                    builder: (context, state) {
                      return Lottie.asset(state.imagePath, repeat: false);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
