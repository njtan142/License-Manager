import 'package:flutter/material.dart';

class OfficerPositionDropdown extends StatefulWidget {
  final void Function(String?)? onChanged;
  const OfficerPositionDropdown({super.key, this.onChanged});

  @override
  State<OfficerPositionDropdown> createState() =>
      _OfficerPositionDropdownState();
}

class _OfficerPositionDropdownState extends State<OfficerPositionDropdown> {
  String _selectedPosition = 'Patrol Officer';

  List<String> _positions = [
    'Patrol Officer',
    'Enforcement Officer',
    'Traffic Investigator',
    'Traffic Control Supervisor',
    'Traffic Operations Officer',
    'Traffic Safety Officer'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        dropdownColor: Color.fromARGB(255, 50, 45, 71),
        value: _selectedPosition,
        items: _positions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          _selectedPosition = value!;
        },
      ),
    );
  }
}
