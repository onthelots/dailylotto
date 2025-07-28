import 'dart:io';
import 'package:dailylotto/src/presentation/weekly/weekly_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../home/home_screen.dart';
import '../mypage/mypage_screen.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_event.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_state.dart';

class MainScreen extends StatelessWidget {

  final List<Widget> _tabs = [
    const HomeScreen(),
    const WeeklyScreen(),
    const MyPageScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, TabState>(
        builder: (context, state) {
          final currentIndex = (state).index; // 기본값 0
          return Scaffold(
            // IndexedStack을 사용하여 탭 전환
            body: IndexedStack(
              index: currentIndex,
              children: _tabs,
            ),
            bottomNavigationBar: Platform.isIOS
                ? CupertinoTabBar(
              currentIndex: currentIndex,
              items: CustomBottomNavigationBar.bottomNavigationBarItem,
              onTap: (index) {
                context.read<BottomNavBloc>().add(TabSelected(index)); // 이벤트 전달
              },
              activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.white10,
              backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            )
                : BottomNavigationBar(
              currentIndex: currentIndex,
              items: CustomBottomNavigationBar.bottomNavigationBarItem,
              onTap: (index) {
                context.read<BottomNavBloc>().add(TabSelected(index)); // 이벤트 전달
              },
              selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            ),
          );
        },
      ),
    );
  }
}
