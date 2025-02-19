import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTitleDisplay extends StatelessWidget {
  const HomeTitleDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<TimeBloc, TimeState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.title,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                state.subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ],
          );
        },
      ),
    );
  }
}
