import 'package:dailylotto/src/data/sources/report_remote_data_source.dart';

abstract class ReportRepository {
  Future<void> submitReport(Map<String, dynamic> reportData);
}

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitReport(Map<String, dynamic> reportData) async {
    await remoteDataSource.submitReport(reportData);
  }
}
