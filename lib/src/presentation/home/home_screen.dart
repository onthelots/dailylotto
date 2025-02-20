import 'package:dailylotto/src/core/utils.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_card_display.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_title_display.dart';
import 'package:dailylotto/src/presentation/home/widgets/home_number_display.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[

        // <----- 확장 AppBar ----->
        SliverAppBar(
          scrolledUnderElevation: 0.0,
          expandedHeight: 200,
          // 동적 높이 반영, // 고정된 값으로 높이 설정
          floating: false,
          pinned: false,
          // 📌 스크롤 시 앱바 고정
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeader(context), // 📌 스크롤 전 상단 UI
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // TODO: - Trailing (Notification)
              },
            ),
          ],
        ),

        // <----- 번호관련 Header (스크롤 시 AppBar는 사라지지만, Header는 pinned 속성을 통해 고정 가능) ----->
        SliverPersistentHeader(
          pinned: false,
          delegate: _LottoNumberHeaderDelegate(
            child: const LottoNumberDisplay(),
            minExtent: 80, // 최소 높이 (필요에 따라 조정)
            maxExtent: 80, // 최대 높이 (필요에 따라 조정)
          ),
        ),

        // <----- Sliver Box (스크롤 가능한 컨텐츠) ----->
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              children: [
                HomeCardDisplay(),
              ],
            ),
          ),
        )
      ]),
    );
  }

  // 스크롤 전 보이는 헤더 UI
  Widget _buildHeader(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: HomeTitleDisplay(),
        ),
        SizedBox(
          height: 15.0,
        )
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _LottoNumberHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate._minExtent != _minExtent ||
        oldDelegate._maxExtent != _maxExtent;
  }
}