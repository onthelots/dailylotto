import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> init() async {
    await _initializePlugin();
    await _setupFirebaseMessaging();
  }

  Future<void> _initializePlugin() async {
    const initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 채널 생성 (Android)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Background 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ 알림 권한 허용됨");
      await _subscribeToDefaultTopics();
    } else {
      print("❌ 알림 권한 거부됨");
    }

    // Foreground 수신 시 로컬 알림 표시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_notification',
            ),
          ),
        );
      }
    });
  }

  // 모든 알림/뱃지 제거
  Future<void> clearAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _subscribeToDefaultTopics() async {
    final prefs = await SharedPreferences.getInstance();

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

  Future<AuthorizationStatus> checkNotificationPermission() async {
    return (await FirebaseMessaging.instance.getNotificationSettings()).authorizationStatus;
  }
}

// Background 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background message received: ${message.messageId}');
}
