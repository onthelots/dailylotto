import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  // 알림 권한 상태 확인 메서드
  Future<AuthorizationStatus> checkNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 알림 권한 요청을 하지 않고 상태만 확인
    NotificationSettings settings = await messaging.getNotificationSettings();

    return settings.authorizationStatus;
  }
}