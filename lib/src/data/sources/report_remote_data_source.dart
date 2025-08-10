import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitReport(Map<String, dynamic> reportData);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseFirestore firestore;

  ReportRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> submitReport(Map<String, dynamic> reportData) async {
    await firestore.collection('reports').add(reportData);
  }
}
