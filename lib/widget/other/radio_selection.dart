import 'package:flutter/material.dart';

class RadioSelection extends StatelessWidget {
  final String title;
  final String? selectedOption;
  final VoidCallback onTap;
  final Function(String?) onChanged;
  const RadioSelection({
    super.key,
    required this.title,
    required this.selectedOption,
    required this.onTap,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<String>(
        activeColor: theme.colorScheme.secondary,
        value: title,
        // ignore: deprecated_member_use
        groupValue: selectedOption,
        // ignore: deprecated_member_use
        onChanged: onChanged,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 12,
          fontWeight: FontWeight.normal
        ),
      ),
      onTap: onTap,
    );
  }
}