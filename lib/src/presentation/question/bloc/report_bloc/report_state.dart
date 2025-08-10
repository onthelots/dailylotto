import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {}

class ReportFailure extends ReportState {
  final String message;

  const ReportFailure({required this.message});

  @override
  List<Object> get props => [message];
}
