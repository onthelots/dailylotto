import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitReportEvent extends ReportEvent {
  final Map<String, dynamic> reportData;

  const SubmitReportEvent({required this.reportData});

  @override
  List<Object> get props => [reportData];
}
