import 'package:dailylotto/src/core/di/locator.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dailylotto/src/core/routes.dart';
import 'package:dailylotto/src/core/shared_preference.dart';
import 'package:dailylotto/src/core/theme.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final _router = AppRouter();

  MyApp({Key? key, required this.initialRoute}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(ThemeInitialEvent()), // 앱 실행 시 테마 초기화
        ),
        BlocProvider(
          create: (context) => locator<LottoRemoteBloc>()..add(FetchLatestRound()),
        ),
        BlocProvider(
          create: (context) => locator<LottoLocalBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LottoRemoteBloc, LottoRemoteState>(
            listener: (context, state) {
              if (state is LottoLoaded) {
                final remoteRound = state.latestRound.round;
                print(">>> 앱 초기 시점에, Remote로 부터 latestRound값 받아오기 ${remoteRound}");
                context
                    .read<LottoLocalBloc>()
                    .add(LoadLottoNumbersEvent(remoteRound));
              }
            },
          ),
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

