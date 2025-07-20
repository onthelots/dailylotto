import 'package:dailylotto/src/core/app_info/app_info_cubit.dart';
import 'package:dailylotto/src/core/di/locator.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_bloc.dart';
import 'package:dailylotto/src/presentation/home/bloc/time_bloc/time_event.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_bloc.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_state.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:dailylotto/src/core/routes.dart';
import 'package:dailylotto/src/core/shared_preference.dart';
import 'package:dailylotto/src/core/theme.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_state.dart';
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/daily_question_bloc.dart';
import 'package:dailylotto/src/presentation/question/bloc/daily_question_event.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  // env (gemini api key)
  await dotenv.load(fileName: ".env"); // env (api key)

  // 앱 구동여부 확인
  final bool isFirstRun = await SharedPreferencesHelper.getFirstRunState();
  final String initialRoute = isFirstRun ? Routes.introduce : Routes.main;

  // Firebase, DI(Locator), Hive를 병렬로 초기화
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    setupLocator(),
  ]);

  // run
  Future.delayed(Duration(seconds: 2), () {
    runApp(MyApp(initialRoute: initialRoute));
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  int currentRound = 0; // 현재 진행중인 라운드를 갱신
  final _router = AppRouter();

  MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(ThemeInitialEvent()), // 앱 실행 시 테마 초기화
        ),
        BlocProvider(
          create: (context) => TimeBloc(), // 시간 가져오기
        ),
        BlocProvider(
          create: (context) => locator<LottoRemoteBloc>()..add(FetchLatestRound()),
        ),
        BlocProvider(
          create: (context) => locator<LottoLocalBloc>(),
        ),
        BlocProvider(
          create: (context) => locator<WeeklyLottoBloc>(),
        ),
        BlocProvider(
          create: (context) => locator<LatestRoundBloc>()..add(LoadLatestRoundEvent()),
        ),
        BlocProvider(
          create: (context) => locator<DailyQuestionBloc>()..add(LoadDailyQuestionEvent()),
        ),
        // version
        BlocProvider(
          create: (context) => AppInfoCubit()..fetchAppVersion(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [

          // Listener 1 : 최신 회차 추첨(업데이트)에 따른 갱신
          BlocListener<LottoRemoteBloc, LottoRemoteState>(
            listener: (context, state) {
              if (state is LottoLoaded) {

                // 진행되는 현재 회차값을 활용해야 함
                // 따라서, Firebase에 있는 값은, latestRound이니, 앞으로 다가올 값을 적용하기 위해 +1을 실시함
                final currentRound = state.latestRound.round + 1;
                this.currentRound = currentRound;

                // 1. 업데이트 (여기서는, latestRound값을 활용)
                context
                    .read<LottoLocalBloc>()
                    .add(UpdateWinningNumbersEvent(
                    round: state.latestRound.round,
                    winningNumbers: state.latestRound.winningNumbers,
                    bonusNumber: state.latestRound.bonusNumber));

                // 2. 이번주 데이터 불러오기 (여기서는 currentRound를 활용)
                context
                    .read<WeeklyLottoBloc>()
                    .add(LoadWeeklyLottoEvent(round: currentRound));

                // 3. Local 내 저장된 최근회차 나타내기 (2번째 탭)
                context.read<LatestRoundBloc>().add(LoadLatestRoundEvent());

                // 4. 타이머 리셋
                context
                    .read<TimeBloc>()
                    .add(RefreshTimeEvent());
              }
            },
          ),

          // Listener 2 : 번호 생성 완료 시, Weekly State 업데이트
          BlocListener<LottoLocalBloc, LottoLocalState>(listener: (context, state) {
            if (state is DailyLottoNumberCreated) {
              context
                  .read<WeeklyLottoBloc>()
                  .add(LoadWeeklyLottoEvent(round: currentRound));
            }
          })
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final themeMode =
            (state is ThemeInitial) ? state.themeMode : ThemeMode.system;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: initialRoute,
              onGenerateRoute: _router.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}

