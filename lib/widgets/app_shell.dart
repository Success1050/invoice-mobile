import 'package:flutter/material.dart';
import 'sidebar.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppShell({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.bgPrimary,
        elevation: 0,
        actions: actions ?? [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: AppTheme.textSecondary),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: AppTheme.accentBlue, shape: BoxShape.circle),
                    constraints: BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              backgroundColor: AppTheme.accentIndigo,
              radius: 16,
              child: Text('E', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      drawer: Sidebar(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
