import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/customer.dart';
import '../widgets/app_shell.dart';
import '../widgets/customer_card.dart';
import '../widgets/search_bar.dart';
import '../theme/app_theme.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataProvider>().fetchCustomers());
  }

  void _showAddCustomerDialog([Customer? editingCustomer]) {
    final data = context.read<DataProvider>();
    final nameController = TextEditingController(text: editingCustomer?.name ?? '');
    final emailController = TextEditingController(text: editingCustomer?.email ?? '');
    final phoneController = TextEditingController(text: editingCustomer?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  editingCustomer != null ? 'Edit Customer' : 'New Customer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 24),
            Text('FULL NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
            SizedBox(height: 8),
            TextField(controller: nameController, decoration: InputDecoration(hintText: 'e.g. John Doe')),
            SizedBox(height: 20),
            Text('EMAIL ADDRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
            SizedBox(height: 8),
            TextField(controller: emailController, decoration: InputDecoration(hintText: 'john@example.com')),
            SizedBox(height: 20),
            Text('PHONE NUMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
            SizedBox(height: 8),
            TextField(controller: phoneController, decoration: InputDecoration(hintText: '080 000 0000')),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final success = editingCustomer != null
                      ? await data.updateCustomer(editingCustomer.id, nameController.text, emailController.text, phoneController.text)
                      : await data.addCustomer(nameController.text, emailController.text, phoneController.text);
                  if (success && context.mounted) Navigator.pop(context);
                },
                child: Text(editingCustomer != null ? 'Save Changes' : 'Create Customer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();

    final filteredCustomers = data.customers.where((c) {
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.phone?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    return AppShell(
      title: 'Customers',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomerDialog(),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('New Customer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.accentBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: AppSearchBar(
              placeholder: 'Search by name, email or phone...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: data.isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredCustomers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.2)),
                            SizedBox(height: 16),
                            Text('No customers found', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CustomerCard(
                            customer: filteredCustomers[index],
                            onTap: () {},
                            onEdit: () => _showAddCustomerDialog(filteredCustomers[index]),
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppTheme.bgSecondary,
                                  title: Text('Delete Customer'),
                                  content: Text('Are you sure you want to delete this customer? All associated invoices will also be deleted.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete', style: TextStyle(color: AppTheme.accentRose))),
                                  ],
                                ),
                              );
                              if (confirm == true) await data.deleteCustomer(filteredCustomers[index].id);
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
