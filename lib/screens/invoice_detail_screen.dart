import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';
import '../theme/app_theme.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    final dateFormat = DateFormat('MMM dd, yyyy · hh:mm a');

    Color statusColor;
    switch (invoice.status.toLowerCase()) {
      case 'paid': statusColor = AppTheme.accentEmerald; break;
      case 'pending': statusColor = AppTheme.accentAmber; break;
      case 'overdue': statusColor = AppTheme.accentRose; break;
      default: statusColor = AppTheme.textMuted;
    }

    return Scaffold(
      backgroundColor: AppTheme.bgSecondary,
      appBar: AppBar(
        title: Text('Invoice #${invoice.id}', style: TextStyle(fontSize: 16)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 20)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                invoice.status.toUpperCase(),
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
            ),
            SizedBox(height: 32),
            
            // Amount Heading
            Text('AMOUNT DUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1.5)),
            SizedBox(height: 12),
            Text(
              currencyFormat.format(invoice.amount).replaceAll('NGN', '₦'),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            SizedBox(height: 40),
            
            // Info Card
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppTheme.borderSubtle, width: 0.5),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'REFERENCE', value: invoice.description ?? 'No reference provided'),
                  Divider(height: 48, color: AppTheme.borderSubtle),
                  _DetailRow(label: 'CLIENT NAME', value: invoice.customer?.name ?? 'Unknown Client'),
                  Divider(height: 48, color: AppTheme.borderSubtle),
                  _DetailRow(label: 'CLIENT EMAIL', value: invoice.customer?.email ?? 'N/A'),
                  Divider(height: 48, color: AppTheme.borderSubtle),
                  _DetailRow(label: 'CREATED DATE', value: dateFormat.format(DateTime.now())), // Would use actual date if available in model
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // Future PDF download?
                    icon: Icon(Icons.download_rounded, size: 20),
                    label: Text('Download PDF'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {}, // Future email link
                    icon: Icon(Icons.send_rounded, size: 20),
                    label: Text('Send Link'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1)),
        SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
