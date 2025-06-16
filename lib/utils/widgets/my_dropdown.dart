import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final IconData? prefixIcon;
  final bool isRequired;
  final String? Function(T?)? validator;

  const MyDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.prefixIcon,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      hint: hint != null ? Text(hint!) : null,
      items: items,
      validator: validator ?? (isRequired ? _defaultValidator : null),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  String? _defaultValidator(T? value) {
    return value == null ? 'Please select $label' : null;
  }
}
