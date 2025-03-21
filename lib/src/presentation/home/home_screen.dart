import 'package:dailylotto/src/core/constants.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_state.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_card_display.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_title_display.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_number_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(), // iOS 스타일 부드러운 스크롤
            slivers: <Widget>[
              SliverAppBar(
                scrolledUnderElevation: 0.0,
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: state.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context),
                ),
              ),

              SliverPersistentHeader(
                pinned: false,
                delegate: _LottoNumberHeaderDelegate(
                  child: const LottoNumberDisplay(),
                  minExtent: 80,
                  maxExtent: 80,
                ),
              ),

              const SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: boxPadding, vertical: boxPadding),
                  child: HomeCardDisplay(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 스크롤 전 보이는 헤더 UI
  Widget _buildHeader(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: boxPadding),
          child: HomeTitleDisplay(),
        ),
      ],
    );
  }
}

// SliverPersistentHeaderDelegate 구현
class _LottoNumberHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double _minExtent;
  final double _maxExtent;

  _LottoNumberHeaderDelegate({
    required this.child,
    required double minExtent,
    required double maxExtent,
  })  : _minExtent = minExtent,
        _maxExtent = maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _LottoNumberHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate._minExtent != _minExtent ||
        oldDelegate._maxExtent != _maxExtent;
  }
}