import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/data/sources/lotto_local_datasource.dart';
import 'package:dailylotto/src/data/sources/lotto_remote_datasource.dart';
import 'package:dailylotto/src/domain/repositories/cst_question_repository.dart';
import 'package:dailylotto/src/domain/repositories/lotto_remote_repository.dart';
import 'package:dailylotto/src/domain/usecases/lotto_remote_usecase.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_local_bloc/lotto_local_bloc.dart';
import 'package:dailylotto/src/presentation/main/bloc/lotto_remote_bloc/lotto_remote_bloc.dart';
import 'package:dailylotto/src/presentation/question/bloc/question_bloc.dart';
import 'package:dailylotto/src/presentation/weekly/bloc/latest_round_bloc/latest_round_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/sources/cst_question_datasource.dart';
import '../../domain/repositories/lotto_local_repository.dart';
import '../../domain/usecases/cst_question_usecase.dart';
import '../../domain/usecases/lotto_local_usecase.dart';
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



  /// Game
  locator.registerLazySingleton<QuestionDataSource>(
          () => QuestionDataSource());

  locator.registerLazySingleton<CstQuestionRepository>(
          () => CstQuestionRepository(dataSource: locator<QuestionDataSource>()));

  locator.registerLazySingleton<GetThreeRandomQuestionsUseCase>(
          () => GetThreeRandomQuestionsUseCase(repository: locator<CstQuestionRepository>()));

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

  // 5. cst_question
  locator.registerFactory<QuestionBloc>(
          () => QuestionBloc(useCase: locator<GetThreeRandomQuestionsUseCase>()));
}
