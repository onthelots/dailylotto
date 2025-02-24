import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final int selectedYear;
  final int selectedMonth;
  final Function(int, int) onFilterSelected;
  final VoidCallback onResetFilter; // 초기화 버튼을 위한 콜백 추가

  const FilterDialog({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onFilterSelected,
    required this.onResetFilter, // 초기화 기능 추가
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
    _selectedMonth = widget.selectedMonth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '월별 조회하기',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                widget.onResetFilter(); // 초기화 실행
                Navigator.pop(context);
              },
              tooltip: '초기화',
              icon: Icon(Icons.refresh_outlined))
        ],
      ),
      content: Row(
        children: [
          DropdownButton<int>(
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            value: _selectedYear,
            items: List.generate(
              10,
                  (index) => DropdownMenuItem(
                value: DateTime.now().year - index,
                child: Text('${DateTime.now().year - index}년', style: Theme.of(context).textTheme.bodyMedium,),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedYear = value;
                });
              }
            },
          ),
          const SizedBox(width: 30,),

          // 월 선택 드롭다운
          DropdownButton<int>(
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            value: _selectedMonth,
            items: List.generate(
              12,
                  (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}월', style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMonth = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text('취소', style: Theme.of(context).textTheme.labelMedium),
        ),
        TextButton(
          onPressed: () {
            widget.onFilterSelected(_selectedYear, _selectedMonth);
            Navigator.pop(context);
          },
          child:  Text('적용', style: Theme.of(context).textTheme.labelMedium),
        ),
      ],
    );
  }
}
