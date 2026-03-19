import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/invoices_screen.dart';
import '../screens/customers_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppTheme.bgSecondary,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderSubtle, width: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentIndigo]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: AppTheme.accentBlue.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Center(
                    child: Text('I', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'InvoiceFlow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MENU',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          _NavItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isActive: true, // Simplified
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen())),
          ),
          _NavItem(
            icon: Icons.description_outlined,
            label: 'Invoices',
            isActive: false,
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InvoicesScreen())),
          ),
          _NavItem(
            icon: Icons.people_outline,
            label: 'Customers',
            isActive: false,
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomersScreen())),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.1)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.accentBlue.withValues(alpha: 0.05), Colors.transparent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('InvoiceFlow Pro', style: TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    'Manage invoices & customers with advanced analytics',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? AppTheme.accentBlue.withValues(alpha: 0.1) : Colors.transparent,
        visualDensity: VisualDensity.compact,
        leading: Icon(icon, color: isActive ? AppTheme.accentBlue : AppTheme.textSecondary, size: 20),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.accentBlue : AppTheme.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
