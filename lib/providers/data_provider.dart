import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/invoice.dart';
import '../services/api_service.dart';

class DataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Customer> _customers = [];
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getCustomers(),
        _apiService.getInvoices(),
      ]);

      _customers = results[0] as List<Customer>;
      _invoices = results[1] as List<Invoice>;
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCustomers() async {
    _customers = await _apiService.getCustomers();
    notifyListeners();
  }

  Future<void> fetchInvoices() async {
    _invoices = await _apiService.getInvoices();
    notifyListeners();
  }

  // Customer CRUD
  Future<bool> addCustomer(String name, String email, String phone) async {
    final success = await _apiService.createCustomer(
      Customer(id: 0, name: name, email: email, phone: phone),
    );
    if (success != null) {
      await fetchCustomers();
      return true;
    }
    return false;
  }

  Future<bool> updateCustomer(int id, String name, String email, String phone) async {
    final success = await _apiService.updateCustomer(
      id,
      Customer(id: id, name: name, email: email, phone: phone),
    );
    if (success) {
      await fetchCustomers();
      return true;
    }
    return false;
  }

  Future<bool> deleteCustomer(int id) async {
    final success = await _apiService.deleteCustomer(id);
    if (success) {
      await fetchAll(); // Re-fetch all because invoices might be affected
      return true;
    }
    return false;
  }

  // Invoice CRUD
  Future<bool> addInvoice(int customerId, double amount, String status, String description) async {
    final success = await _apiService.createInvoice({
      'customerId': customerId,
      'amount': amount,
      'status': status,
      'description': description,
    });
    if (success != null) {
      await fetchInvoices();
      return true;
    }
    return false;
  }

  Future<bool> updateInvoice(int id, int customerId, double amount, String status, String description) async {
    final success = await _apiService.updateInvoice(id, {
      'customerId': customerId,
      'amount': amount,
      'status': status,
      'description': description,
    });
    if (success) {
      await fetchInvoices();
      return true;
    }
    return false;
  }

  Future<bool> deleteInvoice(int id) async {
    final success = await _apiService.deleteInvoice(id);
    if (success) {
      await fetchInvoices();
      return true;
    }
    return false;
  }
}
