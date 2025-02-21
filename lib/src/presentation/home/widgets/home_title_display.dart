import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeTitleDisplay extends StatefulWidget {
  const HomeTitleDisplay({super.key});

  @override
  State<HomeTitleDisplay> createState() => _HomeTitleDisplayState();
}

class _HomeTitleDisplayState extends State<HomeTitleDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationLoaded = false; // 애니메이션 로딩 여부 확인

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this); // duration 없이 초기화
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // <----- 타이틀 ---->
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.title,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        state.subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.date,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // <----- Lottie 이미지 (앱 실행 시 자동 실행 + 클릭하면 다시 실행) ---->
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (_isAnimationLoaded) {
                        _controller.reset();
                        _controller.forward();
                      }
                    },
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: Lottie.asset(
                        state.imagePath,
                        controller: _controller,
                        repeat: false,
                        onLoaded: (composition) {
                          setState(() {
                            _controller.duration = composition.duration; // Lottie 애니메이션의 duration 설정
                            _isAnimationLoaded = true;
                          });
                          _controller.forward(); // duration이 설정된 후 실행
                        },
                      ),
                    ),
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
