import 'package:flutter/material.dart';

/// Single-select dropdown for a fixed list of string ids (ostype, scsihw, …).
class GuestStringDropdown extends StatelessWidget {
  const GuestStringDropdown({
    required this.label,
    required this.ids,
    required this.value,
    this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String label;
  final List<String> ids;
  final String value;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final effective =
        ids.contains(value) ? value : (ids.isNotEmpty ? ids.first : value);
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: effective,
      decoration: InputDecoration(labelText: label),
      items:
          ids
              .map((id) => DropdownMenuItem<String>(value: id, child: Text(id)))
              .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}
