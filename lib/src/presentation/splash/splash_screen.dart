import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          _permissionWithNotification();

        },
        child: Text("권한 허용"),
      ),
    );
  }

  void _permissionWithNotification() async {
    await [Permission.notification].request();
  }
}
