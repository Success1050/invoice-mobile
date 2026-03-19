import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../theme/app_theme.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    getInitials(customer.name),
                    style: TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      customer.email,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null) ...[
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: AppTheme.accentBlue),
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: AppTheme.accentRose),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ] else ...[
                Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
