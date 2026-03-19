import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../providers/data_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/invoice_card.dart';
import 'invoice_detail_screen.dart';
import 'invoices_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    final data = context.watch<DataProvider>();
    final invoicesForClient = data.invoices.where((i) => i.customerId == customer.id).toList();
    final totalSpent = invoicesForClient
        .where((i) => i.status.toLowerCase() == 'paid')
        .fold(0.0, (sum, i) => sum + i.amount);

    return Scaffold(
      backgroundColor: AppTheme.bgSecondary,
      appBar: AppBar(
        title: Text(customer.name, style: TextStyle(fontSize: 16)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 20)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.accentBlue, AppTheme.accentIndigo], begin: Alignment.topLeft),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: AppTheme.accentBlue.withValues(alpha: 0.3), blurRadius: 40)],
              ),
              child: Center(
                child: Text(
                  customer.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 32),
            
            // Stats Grid
            Row(
              children: [
                _MiniStat(label: 'PAID REVENUE', value: currencyFormat.format(totalSpent), color: AppTheme.accentEmerald),
                SizedBox(width: 16),
                _MiniStat(label: 'INVOICES', value: invoicesForClient.length.toString(), color: AppTheme.accentBlue),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Details List
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppTheme.borderSubtle, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'EMAIL', value: customer.email, icon: Icons.alternate_email_rounded),
                  Divider(height: 48, color: AppTheme.borderSubtle),
                  _InfoRow(label: 'PHONE', value: customer.phone ?? 'N/A', icon: Icons.phone_rounded),
                  Divider(height: 48, color: AppTheme.borderSubtle),
                  _InfoRow(label: 'CUSTOMER ID', value: '#${customer.id}', icon: Icons.badge_rounded),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Recent Invoices Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Client Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoicesScreen(initialCustomerId: customer.id))),
                  child: Text('View All →', style: TextStyle(color: AppTheme.accentBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (invoicesForClient.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(24)),
                child: Column(children: [Text('No transactions yet', style: TextStyle(color: AppTheme.textMuted))]),
              )
            else
              Column(
                children: invoicesForClient.reversed.take(10).map((inv) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InvoiceCard(
                    invoice: inv,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: inv))),
                  ),
                )).toList(),
              ),
              
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppTheme.borderSubtle, width: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.bgSecondary, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: AppTheme.accentBlue),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
