import 'package:flutter/material.dart';

class DriverLicenseTypeDropdown extends StatefulWidget {
  final void Function(String?)? onChanged;
  const DriverLicenseTypeDropdown({super.key, this.onChanged});

  @override
  State<DriverLicenseTypeDropdown> createState() =>
      _DriverLicenseTypeDropdownState();
}

class _DriverLicenseTypeDropdownState extends State<DriverLicenseTypeDropdown> {
  String _selectedType = 'Non-Professional Driver\'s License';

  List<String> _types = [
    'Student Permit',
    'Non-Professional Driver\'s License',
    'Professional Driver\'s License',
    'Conductor\'s License',
    'Motorcycle License',
    'Commercial Driver\'s License'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        value: _selectedType,
        items: _types.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          _selectedType = value!;
        },
      ),
    );
  }
}
