import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/routes.dart';

class WarningCheckDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  const WarningCheckDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
    this.confirmText = '확인',
    this.cancelText = '취소',
  });

  @override
  Widget build(BuildContext context) {
    // RichText로 추가 링크 포함한 컨텐츠 구성
    final contentWidget = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: "$subtitle\n\n"),
          TextSpan(
            text: "서비스 이용 주의사항 확인하기",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, Routes.webView,
                    arguments: WebRoutes.warning);
              },
          ),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoTheme(
            data: CupertinoThemeData(
                scaffoldBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor),
            child: CupertinoAlertDialog(
              title: Column(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).primaryColor,
                    size: 30.0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: contentWidget,
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    cancelText,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Theme.of(context).dividerColor),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Text(
                    confirmText,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Theme.of(context).focusColor),
                  ),
                ),
              ],
            ),
          )
        : AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Column(
              children: [
                Icon(
                  Icons.warning,
                  color: Theme.of(context).primaryColor,
                  size: 30.0,
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  cancelText,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).dividerColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: Text(
                  confirmText,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).focusColor),
                ),
              ),
            ],
          );
  }
}