import 'dart:io';
import 'package:dailylotto/src/presentation/weekly/weekly_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';
import '../home/home_screen.dart';
import '../mypage/mypage_screen.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_event.dart';
import 'bloc/bottom_nav_bloc/bottom_nav_state.dart';

@pragma('vm:entry-point') // ✅ AOT 컴파일에서 삭제되지 않도록 보호
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
    fcmSetting(); // fcm 세팅
    checkInitialMessage(); //
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
      await _checkAndSubscribeTopics();

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

    /// 알림 띄우기
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

    /// 알림 탭 시, 이동하는 화면
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  void handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      String? topic = message.data['topic'];
      print("🔔 푸시 알림 수신: topic = $topic");

      if (topic == 'notice_topic') {
        Navigator.of(context).pushNamed(Routes.notice);
      } else {
        print("⚠️ 해당 알림은 이동할 화면이 없음");
      }
    }
  }

  Future<void> _checkAndSubscribeTopics() async {
    final prefs = await SharedPreferences.getInstance();

    // 키가 없을 경우에만 기본값 true로 설정
    if (!prefs.containsKey('notice_topic')) {
      await prefs.setBool('notice_topic', true);
      await FirebaseMessaging.instance.subscribeToTopic('notice_topic');
    }
    if (!prefs.containsKey('daily_topic')) {
      await prefs.setBool('daily_topic', true);
      await FirebaseMessaging.instance.subscribeToTopic('daily_topic');
    }
    if (!prefs.containsKey('weekly_topic')) {
      await prefs.setBool('weekly_topic', true);
      await FirebaseMessaging.instance.subscribeToTopic('weekly_topic');
    }
  }

  final List<Widget> _tabs = [
    HomeScreen(),
    WeeklyScreen(),
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
