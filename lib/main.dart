import 'package:dailylotto/src/core/notification_service.dart';
import 'package:dailylotto/src/core/routes.dart';
import 'package:dailylotto/src/core/theme.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_event.dart';
import 'package:dailylotto/src/presentation/main/bloc/theme_bloc/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // env (gemini api key)
  await dotenv.load(fileName: ".env"); // env (api key)

  // run
  Future.delayed(Duration(seconds: 2), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(ThemeInitialEvent()), // 앱 실행 시 테마 초기화
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
            initialRoute: Routes.main,
            onGenerateRoute: _router.onGenerateRoute,
          );
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late final QuestionBloc _questionBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     final questionRepository = CstQuestionRepository(QuestionDataSource());
//     final getThreeRandomQuestionsUseCase =
//     GetThreeRandomQuestionsUseCase(questionRepository);
//     _questionBloc = QuestionBloc(getThreeRandomQuestionsUseCase);
//     _questionBloc.add(LoadQuestionsEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // ... (기존 코드)
//       ),
//       body: BlocBuilder<QuestionBloc, QuestionState>(
//         bloc: _questionBloc,
//         builder: (context, state) {
//           if (state is QuestionLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is QuestionLoadedState) {
//             return ListView.builder(
//               itemCount: state.questions.length,
//               itemBuilder: (context, index) {
//                 final question = state.questions[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(question.question,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Column(
//                       children: question.options
//                           .map<Widget>((option) => Text(option))
//                           .toList(),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 );
//               },
//             );
//           } else if (state is QuestionErrorState) {
//             return Center(child: Text('Error: ${state.message}'));
//           } else {
//             return const Center(child: Text('Unknown State'));
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _questionBloc.close();
//     super.dispose();
//   }
// }