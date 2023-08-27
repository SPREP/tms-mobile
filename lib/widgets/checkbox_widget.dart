import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    this.value,
    required this.label,
    this.onChanged,
  });

  final bool? value;
  final String label;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 180,
      child: CheckboxListTile(
        value: value,
        activeColor: Colors.blue,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(label),
        onChanged: onChanged,
      ),
    );
  }
}
