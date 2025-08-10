import 'package:dailylotto/src/domain/repositories/report_repository.dart';

class SubmitReportUseCase {
  final ReportRepository repository;

  SubmitReportUseCase({required this.repository});

  Future<void> call(Map<String, dynamic> reportData) async {
    await repository.submitReport(reportData);
  }
}
