import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'invoices_screen.dart';
import 'customers_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0F1E), Color(0xFF0D1A3A), Color(0xFF0A0F1E)],
          ),
        ),
        child: Stack(
          children: [
            // Glows
            Positioned(top: -150, left: -100, child: _Glow(color: AppTheme.accentBlue.withValues(alpha:0.1))),
            Positioned(top: 100, right: -150, child: _Glow(color: AppTheme.accentIndigo.withValues(alpha:0.1))),
            Positioned(bottom: -100, left: 100, child: _Glow(color: AppTheme.accentCyan.withValues(alpha:0.05), width: 400)),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  children: [
                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentIndigo]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: AppTheme.accentBlue.withValues(alpha: 0.4), blurRadius: 20)],
                          ),
                          child: Center(child: Text('I', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))),
                        ),
                        SizedBox(width: 12),
                        Text('InvoiceFlow', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 60),

                    // Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentBlue.withValues(alpha: 0.1),
                        border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('✦', style: TextStyle(color: AppTheme.accentBlue)),
                          SizedBox(width: 8),
                          Text(
                            'Modern Invoice Management Platform',
                            style: TextStyle(color: AppTheme.accentBlue, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    // Headline
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: -1.0),
                        children: [
                          TextSpan(text: 'Manage Invoices &\n'),
                          TextSpan(
                            text: 'Customers with Ease',
                            style: TextStyle(
                              foreground: Paint()..shader = LinearGradient(
                                colors: [AppTheme.accentBlue, AppTheme.accentCyan],
                              ).createShader(Rect.fromLTWH(0, 0, 300, 70)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    Text(
                      'A beautifully crafted platform for tracking invoices, managing customers, and keeping your business finances organized — all in one place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 48),

                    // Nav Buttons
                    _ActionBtn(
                      label: 'Go to Dashboard',
                      icon: Icons.grid_view_rounded,
                      isPrimary: true,
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen())),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            label: 'Invoices',
                            icon: Icons.description_outlined,
                            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InvoicesScreen())),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _ActionBtn(
                            label: 'Customers',
                            icon: Icons.people_outline,
                            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomersScreen())),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 80),

                    // Features grid would go here... skipping most for brevity but adding a few
                    _FeatureTile(icon: Icons.bolt, title: 'Lightning Fast', desc: 'Optimized performance for smooth navigation.'),
                    SizedBox(height: 24),
                    _FeatureTile(icon: Icons.security, title: 'Reliable API', desc: 'Powered by a robust NestJS backend.'),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double width;
  const _Glow({required this.color, this.width = 300});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({required this.label, required this.icon, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: isPrimary ? LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentIndigo]) : null,
          color: isPrimary ? null : AppTheme.bgCard,
          border: Border.all(color: isPrimary ? Colors.transparent : AppTheme.borderSubtle, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isPrimary ? [BoxShadow(color: AppTheme.accentBlue.withValues(alpha: 0.3), blurRadius: 20, offset: Offset(0, 8))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureTile({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.accentBlue, size: 32),
          SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
