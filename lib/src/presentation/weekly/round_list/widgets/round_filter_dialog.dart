import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class FilterDialog extends StatefulWidget {
  final int selectedYear;
  final int selectedMonth;
  final Function(int, int) onFilterSelected;
  final VoidCallback onResetFilter;

  const FilterDialog({
    super.key,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onFilterSelected,
    required this.onResetFilter,
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
              widget.onResetFilter();
              Navigator.pop(context);
            },
            tooltip: '초기화',
            icon: Icon(
              Icons.refresh_outlined,
              color: Theme.of(context).hintColor,
            ),
          ),
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
                child: Text(
                  '${DateTime.now().year - index}년',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
          const SizedBox(width: 30),
          DropdownButton<int>(
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            value: _selectedMonth,
            items: List.generate(
              12,
                  (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(
                  '${index + 1}월',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
          child: Text('취소', style: Theme.of(context).textTheme.labelMedium),
        ),
        TextButton(
          onPressed: () {
            widget.onFilterSelected(_selectedYear, _selectedMonth);
            Navigator.pop(context);
          },
          child: Text('적용', style: Theme.of(context).textTheme.labelMedium),
        ),
      ],
    );
  }
}
