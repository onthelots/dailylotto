import 'package:dailylotto/src/domain/usecases/submit_report_use_case.dart';
import 'package:dailylotto/src/presentation/question/bloc/report_bloc/report_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/report_bloc/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final SubmitReportUseCase submitReportUseCase;

  ReportBloc({required this.submitReportUseCase}) : super(ReportInitial()) {
    on<SubmitReportEvent>((event, emit) async {
      emit(ReportLoading());
      try {
        await submitReportUseCase(event.reportData);
        emit(ReportSuccess());
      } catch (e) {
        emit(ReportFailure(message: e.toString()));
      }
    });
  }
}
