// ignore_for_file: library_private_types_in_public_api, use_super_parameters, file_names

import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

class DateInputWidget extends StatefulWidget {
  final void Function(DateTime)? onDateSelected;
  final String label;

  const DateInputWidget({Key? key, required this.label, this.onDateSelected})
      : super(key: key);

  @override
  _DateInputWidgetState createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
              bottom: BorderSide(
                color:
                    Colors.black.withOpacity(0.7), // Specify your desired color
                width: 1, // Specify your desired width
              ),
            ),
      ),
      child: Container(
        
        width: get_screenWidth(context) * 0.3,
        child: TextFormField(
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: nameTitleStyle(context, myred),
            suffixIcon: Container(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              child: Icon(
                Icons.calendar_today,
                color: myred,
                size: get_screenWidth(context)*0.04, // Set the desired size here
              ),
            ),
          ),
          controller: TextEditingController(
            text: _selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : '',
          ),
        ),
      ),
    );
  }
}
