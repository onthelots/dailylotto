import 'package:dailylotto/src/presentation/main/widgets/custom_common_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isNotificationAllowed = false;
  bool _isSubscribedNotice = false;
  bool _isSubscribedDaily = false;
  bool _isSubscribedWeekly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermission();
    }
  }

  /// 알림 권한 확인
  Future<void> _checkNotificationPermission() async {
    NotificationService notificationService = NotificationService();
    AuthorizationStatus status =
        await notificationService.checkNotificationPermission();

    print("🔔 안드로이드 알림 권한 상태: $status"); // 여기서 상태를 꼭 확인

    setState(() {
      _isNotificationAllowed = (status == AuthorizationStatus.authorized);
      print("🔔 알림 권한 상태: $_isNotificationAllowed"); // 로그 추가
    });

    // 알림 허용시
    if (_isNotificationAllowed) {
      // 구독여부 확인
      _checkSubscriptionStatus();
    }
  }

  /// 현재 Firebase Topic 구독 여부 확인 (예제 코드)
  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isSubscribedNotice = prefs.getBool('notice_topic') ?? false;
      _isSubscribedDaily = prefs.getBool('daily_topic') ?? false;
      _isSubscribedWeekly = prefs.getBool('weekly_topic') ?? false;
    });
  }

  /// 특정 Topic 구독
  void _subscribeToTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
      _showLoadingDialog(); // 로딩 다이얼로그 표시
    });

    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      await prefs.setBool(topic, true);

      // 성공 시 UI 업데이트
      setState(() {
        if (topic == 'notice_topic') _isSubscribedNotice = true;
        if (topic == 'daily_topic') _isSubscribedDaily = true;
        if (topic == 'weekly_topic') _isSubscribedWeekly = true;
        _isLoading = false; // 로딩 종료
      });
      Navigator.of(context).pop(); // 다이얼로그 닫기

      print("✅ $topic 구독 완료");
    } catch (error) {
      print("❌ $topic 구독 실패: $error");

      // 실패 시 UI 유지 + 로딩 종료
      setState(() {
        setState(() {
          if (topic == 'notice_topic') _isSubscribedNotice = false;
          if (topic == 'daily_topic') _isSubscribedDaily = false;
          if (topic == 'weekly_topic') _isSubscribedWeekly = false;
          _isLoading = false; // 로딩 종료
        });
        Navigator.of(context).pop(); // 다이얼로그 닫기
      });
    }
  }

  /// 특정 Topic 구독 취소
  void _unsubscribeFromTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();

    // 로딩 상태 활성화
    setState(() {
      _isLoading = true;
      _showLoadingDialog(); // 로딩 다이얼로그 표시
    });

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      await prefs.setBool(topic, false);

      // 성공 시 UI 업데이트
      setState(() {
        if (topic == 'notice_topic') _isSubscribedNotice = false;
        if (topic == 'daily_topic') _isSubscribedDaily = false;
        if (topic == 'weekly_topic') _isSubscribedWeekly = false;
        _isLoading = false; // 로딩 종료
      });
      Navigator.of(context).pop(); // 다이얼로그 닫기

      print("❌ $topic 구독 취소 완료");
    } catch (error) {
      print("⚠️ $topic 구독 취소 실패: $error");

      // 실패 시 UI 원상 복구
      setState(() {
        if (topic == 'notice_topic') _isSubscribedNotice = true;
        if (topic == 'daily_topic') _isSubscribedDaily = true;
        if (topic == 'weekly_topic') _isSubscribedWeekly = true;
        _isLoading = false; // 로딩 종료
      });
      Navigator.of(context).pop(); // 다이얼로그 닫기
    }
  }

  /// iOS 설정 앱으로 이동
  void _openAppSettings() {
    _showPermissionDialog();
  }

  /// Android에서 알림 권한 요청
  Future<void> _requestAndroidPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      _checkNotificationPermission(); // 권한이 허용되었을 때 다시 확인
    } else if (status.isPermanentlyDenied) {
      // "다시 묻지 않음"을 선택한 경우, 설정 페이지로 이동하도록 유도
      _showPermissionDialog();
    }
  }

  /// 사용자가 직접 알림 권한 수정
  void _showPermissionDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomDialog(
        title: '앱 설정으로 이동 후 설정해주세요',
        subtitle: "알림 엑세스 권한을 허용으로 변경해주세요. 이동하시겠어요?",
        cancelText: "취소",
        confirmText: "설정하기",
        onConfirm: () {
          openAppSettings();
        },
      ),
    );
  }

  /// 로딩 인디케이터
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 닫을 수 없도록 설정
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text(
          '알림 설정',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isNotificationAllowed)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.alarm_off_rounded,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '앱 알림이 꺼져있어요',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (Platform.isIOS) {
                        _openAppSettings();
                      } else {
                        _requestAndroidPermission();
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          '알림설정 하기',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Theme.of(context).focusColor),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).focusColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (_isNotificationAllowed) ...[
              Text('푸시 알림 수신 설정',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 10),

              // 📢 Notice Topic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('공지사항 알림',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Switch(
                    activeColor: Theme.of(context).cardColor,
                    activeTrackColor: Theme.of(context).primaryColor,
                    value: _isSubscribedNotice,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            if (value) {
                              _subscribeToTopic('notice_topic');
                            } else {
                              _unsubscribeFromTopic('notice_topic');
                            }
                          },
                  ),
                ],
              ),

              SizedBox(height: 5),

              // 📅 Daily Topic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('일일 알림',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Switch(
                    activeColor: Theme.of(context).cardColor,
                    activeTrackColor: Theme.of(context).primaryColor,
                    value: _isSubscribedDaily,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            if (value) {
                              _subscribeToTopic('daily_topic');
                            } else {
                              _unsubscribeFromTopic('daily_topic');
                            }
                          },
                  ),
                ],
              ),

              SizedBox(height: 5),

              // 📆 Weekly Topic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('추첨시간 알림',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Switch(
                    activeColor: Theme.of(context).cardColor,
                    activeTrackColor: Theme.of(context).primaryColor,
                    value: _isSubscribedWeekly,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            if (value) {
                              _subscribeToTopic('weekly_topic');
                            } else {
                              _unsubscribeFromTopic('weekly_topic');
                            }
                          },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
