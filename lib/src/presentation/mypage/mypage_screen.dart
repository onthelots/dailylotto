import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
          alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
            child: Text('마이페이지', style: Theme.of(context).textTheme.labelLarge),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStreakCard(),

            Divider(
              height: 20.0,
              thickness: 15.0,
              color: Theme.of(context).cardColor,
            ),

            _buildSectionTitle(context: context, title: '앱 설정'),

            _buildListTile(
              context: context,
              title: '알림 설정',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.notification);
              },
            ),
            _buildListTile(
              context: context,
              title: '기본 테마',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.theme);
              },
            ),

            Divider(
              height: 20.0,
              thickness: 15.0,
              color: Theme.of(context).cardColor,
            ),

            _buildSectionTitle(context: context, title: '이용약관 및 라이센스'),

            _buildListTile(
              context: context,
              title: '이용약관 및 개인정보 처리방침',
              onTap: () {

              },
            ),
            _buildListTile(
              context: context,
              title: '오픈소스 라이센스',
              onTap: () {

              },
            ),

            Divider(
              height: 20.0,
              thickness: 15.0,
              color: Theme.of(context).cardColor,
            ),

            _buildListTile(
                context: context,
              title: '앱 버전',
              onTap: () {

              },
              trailing: Text("v1.0.0")
            ),
            _buildListTile(
              context: context,
              title: '동행복권 홈페이지',
              onTap: () {

              },
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: boxPadding, vertical: boxPadding),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('데일리 로또와 함께한지',
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 4),
                Text('25일째',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: boxPadding, vertical: boxPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _buildListTile(
      {required BuildContext context, required String title, required VoidCallback onTap, Widget? trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            trailing ?? const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

/*
Navigator.of(context).pushNamed(Routes.notification);
 */
