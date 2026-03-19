import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../widgets/app_shell.dart';
import '../widgets/stat_card.dart';
import '../widgets/invoice_card.dart';
import '../widgets/customer_card.dart';
import '../theme/app_theme.dart';
import 'invoices_screen.dart';
import 'customers_screen.dart';
import 'customer_detail_screen.dart';
import 'invoice_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataProvider>().fetchAll());
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

    final paidInvoices = data.invoices.where((i) => i.status.toLowerCase() == 'paid').toList();
    final pendingInvoices = data.invoices.where((i) => i.status.toLowerCase() == 'pending').toList();
    final paidAmount = paidInvoices.fold(0.0, (sum, i) => sum + i.amount);
    final pendingAmount = pendingInvoices.fold(0.0, (sum, i) => sum + i.amount);

    final recentInvoices = data.invoices.reversed.take(5).toList();
    final recentCustomers = data.customers.reversed.take(5).toList();

    return AppShell(
      title: 'Dashboard',
      body: RefreshIndicator(
        onRefresh: () => data.fetchAll(),
        backgroundColor: AppTheme.bgSecondary,
        color: AppTheme.accentBlue,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back — here\'s an overview of your business',
                style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500, fontSize: 13),
              ),
              SizedBox(height: 24),
              
              // Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
                children: [
                  StatCard(
                    icon: Icons.description_outlined,
                    label: 'Total Invoices',
                    value: data.isLoading ? '—' : data.invoices.length.toString(),
                    color: AppTheme.accentBlue,
                    sub: '${paidInvoices.length} paid',
                  ),
                  StatCard(
                    icon: Icons.check_circle_outline,
                    label: 'Revenue Collected',
                    value: data.isLoading ? '—' : currencyFormat.format(paidAmount),
                    color: AppTheme.accentEmerald,
                    sub: 'From paid invoices',
                  ),
                  StatCard(
                    icon: Icons.timer_outlined,
                    label: 'Pending',
                    value: data.isLoading ? '—' : pendingInvoices.length.toString(),
                    color: AppTheme.accentAmber,
                    sub: currencyFormat.format(pendingAmount),
                  ),
                  StatCard(
                    icon: Icons.people_outline,
                    label: 'Customers',
                    value: data.isLoading ? '—' : data.customers.length.toString(),
                    color: AppTheme.accentIndigo,
                    sub: 'Total registered',
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Recent Invoices Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Recent Invoices', color: AppTheme.accentBlue),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoicesScreen())),
                    child: Text('View all →', style: TextStyle(color: AppTheme.accentBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (data.isLoading) 
                _LoadingList()
              else if (recentInvoices.isEmpty)
                _EmptyState(icon: Icons.description_outlined, label: 'No invoices yet')
              else
                Column(
                  children: recentInvoices.map((inv) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InvoiceCard(
                      invoice: inv,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: inv))),
                    ),
                  )).toList(),
                ),
                
              SizedBox(height: 32),
              
              // Recent Customers Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Recent Customers', color: AppTheme.accentIndigo),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomersScreen())),
                    child: Text('View all →', style: TextStyle(color: AppTheme.accentIndigo, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (data.isLoading)
                _LoadingList()
              else if (recentCustomers.isEmpty)
                _EmptyState(icon: Icons.people_outline, label: 'No customers yet')
              else
                Column(
                  children: recentCustomers.map((cust) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomerCard(
                      customer: cust,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerDetailScreen(customer: cust))),
                    ),
                  )).toList(),
                ),
                
              SizedBox(height: 48),
              
              // System Health breakdown
              if (!data.isLoading && data.invoices.isNotEmpty) ...[
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
                      Text('System Health & Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 24),
                      _BreakdownItem(
                        label: 'Paid Invoices',
                        count: paidInvoices.length,
                        total: data.invoices.length,
                        color: AppTheme.accentEmerald,
                      ),
                      SizedBox(height: 20),
                      _BreakdownItem(
                        label: 'Pending Payment',
                        count: pendingInvoices.length,
                        total: data.invoices.length,
                        color: AppTheme.accentAmber,
                      ),
                      SizedBox(height: 20),
                      _BreakdownItem(
                        label: 'Overdue Attention',
                        count: data.invoices.where((i) => i.status.toLowerCase() == 'overdue').length,
                        total: data.invoices.length,
                        color: AppTheme.accentRose,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _BreakdownItem({required this.label, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total * 100).round() : 0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1.5)),
            Text(count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: total > 0 ? count / total : 0,
            backgroundColor: AppTheme.bgSecondary,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$pct% of total assets', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            Text('+$pct%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppTheme.textMuted.withValues(alpha: 0.3)),
          SizedBox(height: 12),
          Text(label, style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          height: 72,
          decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16)),
        ),
      )),
    );
  }
}
