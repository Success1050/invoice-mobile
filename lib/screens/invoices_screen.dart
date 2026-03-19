import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../models/invoice.dart';
import '../widgets/app_shell.dart';
import '../widgets/invoice_card.dart';
import '../widgets/search_bar.dart';
import '../theme/app_theme.dart';
import 'invoice_detail_screen.dart';
import '../models/customer.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';
  final List<String> _filters = ['all', 'paid', 'pending', 'overdue', 'draft'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataProvider>().fetchAll());
  }

  void _showAddInvoiceDialog([Invoice? editingInvoice]) {
    final data = context.read<DataProvider>();
    final customerIdController = TextEditingController(text: editingInvoice?.customerId.toString() ?? '');
    final amountController = TextEditingController(text: editingInvoice?.amount.toString() ?? '');
    final descriptionController = TextEditingController(text: editingInvoice?.description ?? '');
    String statusValue = editingInvoice?.status.toLowerCase() ?? 'pending';
    int? selectedCustomerId = editingInvoice?.customerId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editingInvoice != null ? 'Edit Invoice' : 'New Invoice',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                ],
              ),
              SizedBox(height: 24),
              Text('CUSTOMER CLIENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedCustomerId,
                decoration: InputDecoration(
                  hintText: 'Select a registered customer',
                ),
                dropdownColor: AppTheme.bgSecondary,
                items: data.customers
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setModalState(() => selectedCustomerId = val),
              ),
              SizedBox(height: 20),
              Text('AMOUNT (₦)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
              SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '0.00'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: statusValue,
                          decoration: InputDecoration(),
                          dropdownColor: AppTheme.bgSecondary,
                          items: _filters
                              .where((f) => f != 'all')
                              .map((f) => DropdownMenuItem(value: f, child: Text(f.toUpperCase())))
                              .toList(),
                          onChanged: (val) => setModalState(() => statusValue = val!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REFERENCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                        SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(hintText: 'e.g. INV-2024'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCustomerId == null) return;
                    final amt = double.tryParse(amountController.text) ?? 0.0;
                    final success = editingInvoice != null
                        ? await data.updateInvoice(editingInvoice.id, selectedCustomerId!, amt, statusValue, descriptionController.text)
                        : await data.addInvoice(selectedCustomerId!, amt, statusValue, descriptionController.text);
                    if (success && context.mounted) Navigator.pop(context);
                  },
                  child: Text(editingInvoice != null ? 'Update Invoice' : 'Confirm Invoice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

    final filteredInvoices = data.invoices.where((inv) {
      final matchSearch = (inv.customer?.name.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (inv.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          inv.id.toString().contains(_searchQuery);
      final matchStatus = _statusFilter == 'all' || inv.status.toLowerCase() == _statusFilter;
      return matchSearch && matchStatus;
    }).toList();

    final pageTotal = filteredInvoices.fold(0.0, (sum, i) => sum + i.amount);

    return AppShell(
      title: 'Invoices',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddInvoiceDialog(),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('New Invoice', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.accentBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: AppSearchBar(
              placeholder: 'Search by customer, status or ID...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: _filters.map((f) {
                final isActive = _statusFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f.toUpperCase()),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppTheme.accentBlue : AppTheme.textMuted,
                    ),
                    selected: isActive,
                    showCheckmark: false,
                    onSelected: (val) => setState(() => _statusFilter = f),
                    backgroundColor: AppTheme.bgCard,
                    selectedColor: AppTheme.accentBlue.withValues(alpha: 0.1),
                    side: BorderSide(color: isActive ? AppTheme.accentBlue : AppTheme.borderSubtle, width: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
          if (filteredInvoices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Showing ${filteredInvoices.length} results', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    Text('Total: ${currencyFormat.format(pageTotal)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentCyan)),
                  ],
                ),
              ),
            ),
          ],
          Expanded(
            child: data.isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredInvoices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.2)),
                            SizedBox(height: 16),
                            Text('No invoices found', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: filteredInvoices.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InvoiceCard(
                            invoice: filteredInvoices[index],
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: filteredInvoices[index]))),
                            onEdit: () => _showAddInvoiceDialog(filteredInvoices[index]),
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppTheme.bgSecondary,
                                  title: Text('Delete Invoice'),
                                  content: Text('Are you sure you want to delete this invoice?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete', style: TextStyle(color: AppTheme.accentRose))),
                                  ],
                                ),
                              );
                              if (confirm == true) await data.deleteInvoice(filteredInvoices[index].id);
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
