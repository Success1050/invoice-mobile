import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSearchBar extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({
    super.key,
    required this.placeholder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: Icon(Icons.search, color: AppTheme.textMuted, size: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
