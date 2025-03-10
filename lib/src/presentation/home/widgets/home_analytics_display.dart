import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class HomeAnalyticsDisplay extends StatelessWidget {
  const HomeAnalyticsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(contentPaddingIntoBox),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // NEW
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle_rounded,
                            size: 10,
                            color: Theme.of(context).primaryColor,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "UPDATE",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall?.copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
                                ),
                                WidgetSpan(
                                  child: SizedBox(width: 10), // 간격 추가
                                ),
                                TextSpan(
                                  text: "12:00 기준",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // 생성
                    ],
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [

                      // TODO: - 실제 질문 할당할 것
                      TextSpan(
                        text: "사용자가 가장 많이 선택한 번호는?",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 10), // 간격 추가
                      ),
                      TextSpan(
                        text: "28, 29, 30",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
