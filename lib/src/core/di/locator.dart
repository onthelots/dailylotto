import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/data/sources/daily_question_datasource.dart';
import 'package:dailylotto/src/data/sources/lotto_local_datasource.dart';
import 'package:dailylotto/src/data/sources/lotto_remote_datasource.dart';
import 'package:dailylotto/src/domain/repositories/daily_question_repository.dart';
import 'package:dailylotto/src/domain/repositories/lotto_remote_repository.dart';
import 'package:dailylotto/src/domain/usecases/daily_question_usecase.dart';
import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/lotto_stats/bloc/lotto_stats_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/weekly_lotto_bloc/weekly_lotto_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../../domain/repositories/lotto_local_repository.dart';
import '../../domain/usecases/lotto_local_usecase.dart';
import '../../presentation/question/bloc/daily_question_bloc.dart';
import '../../presentation/weekly/bloc/round_list_bloc/round_list_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {

  /// Firebase Firestore
  locator.registerLazySingleton<FirebaseFirestore>(
          () => FirebaseFirestore.instance);

  /// Lotto Remote
  locator.registerLazySingleton<LottoRemoteDataSource>(
          () => LottoRemoteDataSource(locator<FirebaseFirestore>()));

  locator.registerLazySingleton<LottoRemoteRepository>(
          () => LottoRemoteRepository(dataSource: locator<LottoRemoteDataSource>()));

  locator.registerLazySingleton<LottoRemoteUseCase>(
          () => LottoRemoteUseCase(repository: locator<LottoRemoteRepository>()));


  ///  Hive 초기화
  await Hive.initFlutter(); // Hive 초기화
  Hive.registerAdapter(LottoLocalModelAdapter()); // LottoLocalModel 어댑터 등록
  Hive.registerAdapter(LottoEntryAdapter()); // LottoEntry 어댑터 등록

  // <----- Lotto Local ----->
  final box = await Hive.openBox<LottoLocalModel>('lottoBox'); // Hive Box 열기

  locator.registerLazySingleton<LottoLocalDataSource>(
          () => LottoLocalDataSource(box));

  locator.registerLazySingleton<LottoLocalRepository>(
          () => LottoLocalRepository(dataSource: locator<LottoLocalDataSource>()));

  locator.registerLazySingleton<LottoLocalUseCase>(
          () => LottoLocalUseCase(repository: locator<LottoLocalRepository>()));



  /// Daily Question
  locator.registerLazySingleton<DailyQuestionFirebaseDataSource>(
          () => DailyQuestionFirebaseDataSource(firestore: locator<FirebaseFirestore>()));

  locator.registerLazySingleton<DailyQuestionRepository>(
          () => DailyQuestionRepository(dataSource: locator<DailyQuestionFirebaseDataSource>()));

  locator.registerLazySingleton<DailyQuestionUseCase>(
          () => DailyQuestionUseCase(repository: locator<DailyQuestionRepository>()));

  // <----- Bloc ----->

  // 1. Lotto Remote
  locator.registerFactory<LottoRemoteBloc>(
          () => LottoRemoteBloc(useCase: locator<LottoRemoteUseCase>()));

  // 2. Lotto Local
  locator.registerFactory<LottoLocalBloc>(
          () => LottoLocalBloc(useCase: locator<LottoLocalUseCase>()));

  // 3. All Round List
  locator.registerFactory<RoundListBloc>(
          () => RoundListBloc(useCase: locator<LottoLocalUseCase>()));

  // 4. Latest Round List
  locator.registerFactory<LatestRoundBloc>(
          () => LatestRoundBloc(useCase: locator<LottoLocalUseCase>()));

  // 5. question
  locator.registerFactory<DailyQuestionBloc>(
          () => DailyQuestionBloc(getDailyQuestionUseCase: locator<DailyQuestionUseCase>()));

  // 6. Weekly Lotto
  locator.registerFactory<WeeklyLottoBloc>(
          () => WeeklyLottoBloc(useCase: locator<LottoLocalUseCase>()));

  // 7. Lotto Stats
  locator.registerFactory<LottoStatsBloc>(
          () => LottoStatsBloc(useCase: locator<LottoRemoteUseCase>()));
}
