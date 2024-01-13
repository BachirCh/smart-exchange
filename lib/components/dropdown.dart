
import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  final List<String> list;
  final String? initialSelection;
  final String? label;
  final TextEditingController controller;
  final ValueNotifier? value;
  const DropdownMenuExample(
      {super.key, required this.list, required this.controller, this.label, this.initialSelection, this.value });

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = "";
@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: 280,
      initialSelection: widget.initialSelection,
      // validator: widget.validator,
      label: Text(widget.label ?? ""),
      controller: widget.controller,
      // initialSelection: widget.list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          value = dropdownValue;
          widget.controller.text = value!;
        });
      },
      dropdownMenuEntries:
          widget.list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

class DropdownMenuExample2 extends StatefulWidget {
  final List<String> list;
  final Function? changeChrono;
  final String? label;
  final Function? setType;
  const DropdownMenuExample2({
    super.key,
    required this.list,
    this.setType,
    this.label,
    this.changeChrono,
  });

  @override
  State<DropdownMenuExample2> createState() => _DropdownMenuExample2State();
}

class _DropdownMenuExample2State extends State<DropdownMenuExample2> {
  String _value = "Secteur non balayé ou collecté";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Type de constat',
      ),
      value: _value,
      items: widget.list
          .map((e) => DropdownMenuItem(
                value: e,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(e)),
              ))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          _value = newValue.toString();
          widget.changeChrono!(newValue.toString());
          widget.setType!(newValue.toString());
        });
      },
    );
  }
}
