import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   // 알림 초기화
//   static Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   // 매일 12시 알림 설정
//   static Future<void> showDailyAtNoon() async {
//     var timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     var scheduledTime = Time(12, 0, 0); // 12시 (12:00 PM)
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Daily Reminder',
//       'It\'s noon!',
//       _nextInstanceOfTime(scheduledTime),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_channel',
//           'Daily Notifications',
//           'Daily notifications at noon',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       timezone: timeZone,
//     );
//   }
//
//   // 매주 토요일 21시 알림 설정
//   static Future<void> showWeeklyAtNinePm() async {
//     var timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     var scheduledTime = Time(21, 0, 0); // 21시 (9:00 PM)
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1,
//       'Weekly Reminder',
//       'It\'s Saturday 9 PM!',
//       _nextInstanceOfWeekday(scheduledTime, DateTime.saturday),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'weekly_channel',
//           'Weekly Notifications',
//           'Weekly notifications on Saturday at 9 PM',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       timezone: timeZone,
//     );
//   }
//
//   // 주어진 시간을 기반으로 다음 알림 시간 계산
//   static tz.TZDateTime _nextInstanceOfTime(Time time) {
//     final now = tz.TZDateTime.now(tz.local);
//     final nextInstance = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//       time.second,
//     );
//     if (nextInstance.isBefore(now)) {
//       return nextInstance.add(const Duration(days: 1));
//     }
//     return nextInstance;
//   }
//
//   // 주어진 요일에 대한 다음 알림 시간 계산 (매주 토요일)
//   static tz.TZDateTime _nextInstanceOfWeekday(Time time, int weekday) {
//     final now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime nextInstance = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//       time.second,
//     );
//
//     // 요일이 이미 지난 경우, 다음 주로 설정
//     while (nextInstance.weekday != weekday) {
//       nextInstance = nextInstance.add(const Duration(days: 1));
//     }
//
//     return nextInstance;
//   }
// }
