import 'package:flutter/material.dart';

class DropdownMenuExample2 extends StatefulWidget {
  final List<String> list;
  final Function? changeChrono;
  final String? label;
  final Function? setType;
  const DropdownMenuExample2(
      {super.key,
      required this.list,
      this.setType,
      this.label,
      this.changeChrono,});

  @override
  State<DropdownMenuExample2> createState() => _DropdownMenuExample2State();
}

class _DropdownMenuExample2State extends State<DropdownMenuExample2> {
  String _value = "a";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
                          labelText: 'Type de constat',
                        ),
      value: _value,
      items: widget.list
          .map((e) => DropdownMenuItem(
                value: e.toString(),
                child: Text(e.toString()),
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
