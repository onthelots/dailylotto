import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../mypage/mypage_screen.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_event.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_state.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    fcmSetting();
  }

  Future<void> fcmSetting() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ 알림 권한 허용됨");

      // 공지사항 알림 구독
      await messaging.subscribeToTopic('notice_topic');

      // 매일 전송되는 알림 구독
      await messaging.subscribeToTopic('daily_topic');

      // 매일 전송되는 알림 구독
      await messaging.subscribeToTopic('weekly_topic');

    } else {
      print("❌ 알림 권한 거부됨");
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true);

    var initialzationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initialzationSettingsIOS);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (message.notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/launcher_icon',
            ),
          ),
        );
      }
    });
  }

  final List<Widget> _tabs = [
    HomeScreen(),
    HistoryScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, TabState>(
        builder: (context, state) {
          final currentIndex = (state as TabState).index; // 기본값 0
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
