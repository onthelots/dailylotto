import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  const CustomDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
    this.confirmText = '확인',
    this.cancelText = '취소',
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTheme(
            data: CupertinoThemeData(
                scaffoldBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor),
            child: CupertinoAlertDialog(
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text(cancelText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).dividerColor)),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Text(confirmText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).focusColor)),
                ),
              ],
            ),
          )
        : AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(cancelText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).dividerColor)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: Text(confirmText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).focusColor)),
              ),
            ],
          );
  }
}
