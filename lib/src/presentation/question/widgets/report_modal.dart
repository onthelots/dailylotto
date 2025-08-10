import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailylotto/src/data/models/lotto_local_model.dart';
import 'package:dailylotto/src/presentation/question/bloc/report_bloc/report_bloc.dart';
import 'package:dailylotto/src/presentation/question/bloc/report_bloc/report_event.dart';
import 'package:dailylotto/src/presentation/question/bloc/report_bloc/report_state.dart' show ReportState, ReportSuccess, ReportFailure, ReportLoading;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportModal extends StatefulWidget {
  final LottoEntry selectEntry;
  const ReportModal({super.key, required this.selectEntry});

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _detailsController = TextEditingController();
  final FocusNode _detailsFocusNode = FocusNode();

  final List<String> _categories = [
    '유해콘텐츠',
    '음란',
    '차별혐오',
    '기타',
  ];

  double _modalInitialSize = 0.6;

  bool get _isSubmitEnabled {
    return _selectedCategory != null &&
        _detailsController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _detailsFocusNode.addListener(() {
      if (_detailsFocusNode.hasFocus) {
        setState(() {
          _modalInitialSize = 0.75;
        });
      } else {
        setState(() {
          _modalInitialSize = 0.6;
        });
      }
    });

    _detailsController.addListener(() {
      setState(() {}); // 텍스트 입력 변화 감지하여 제출 버튼 활성화 갱신
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final reportData = {
        'category': _selectedCategory,
        'details': _detailsController.text.trim(),
        'recommendReason': widget.selectEntry.recommendReason,
        'dailyTip': widget.selectEntry.dailyTip,
        'timestamp': FieldValue.serverTimestamp(),
      };
      context.read<ReportBloc>().add(SubmitReportEvent(reportData: reportData));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: _modalInitialSize,
      minChildSize: 0.6,
      maxChildSize: 0.85,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 30,
                  left: 16,
                  right: 16,
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '신고하기',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 30),

                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: '카테고리 선택',
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: theme.cardColor, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: theme.highlightColor, width: 0.8),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                          hint: const Text('카테고리를 선택하세요'),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) =>
                          value == null ? '카테고리를 선택해주세요.' : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _detailsController,
                          focusNode: _detailsFocusNode,
                          maxLines: 5,
                          maxLength: 500,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: '신고할 내용을 구체적으로 작성해주세요.',
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: theme.cardColor, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: theme.highlightColor, width: 0.8),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '신고 내용을 입력해주세요.';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.newline,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: theme.hintColor,
                                textStyle: theme.textTheme.titleMedium,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            BlocBuilder<ReportBloc, ReportState>(
                              builder: (context, state) {
                                if (state is ReportLoading) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(100, 44),
                                    ),
                                    onPressed: null,
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                }
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: _isSubmitEnabled
                                        ? theme.primaryColor
                                        : theme.disabledColor,
                                    textStyle: theme.textTheme.titleMedium,
                                  ),
                                  onPressed: _isSubmitEnabled ? _submitReport : null,
                                  child: const Text('제출'),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
