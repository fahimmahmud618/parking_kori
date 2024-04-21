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
      child: InkWell(
        onTap: () => _selectDate(context),
        child: SizedBox(
          width: get_screenWidth(context) * 0.6,
          height: get_screenWidth(context) * 0.1,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.label,
                  style: normalTextStyle(context, myred),
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: myred,
                size: get_screenWidth(context) * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
