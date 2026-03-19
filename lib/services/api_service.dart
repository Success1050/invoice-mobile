import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../models/invoice.dart';

class ApiService {
  // Use http://10.0.2.2:3001 for Android Emulator, or http://localhost:3001 for Web/Desktop
  // For Windows development, localhost should work for Windows target
  static const String baseUrl = 'http://10.116.5.101:5000';

  // --- CUSTOMERS ---
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<Customer?> createCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customer.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creating customer: $e');
      return null;
    }
  }

  Future<bool> updateCustomer(int id, Customer customer) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/customers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customer.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating customer: $e');
      return false;
    }
  }

  Future<bool> deleteCustomer(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/customers/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting customer: $e');
      return false;
    }
  }

  // --- INVOICES ---
  Future<List<Invoice>> getInvoices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/invoices'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Invoice.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching invoices: $e');
      return [];
    }
  }

  Future<Invoice?> createInvoice(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Invoice.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creating invoice: $e');
      return null;
    }
  }

  Future<bool> updateInvoice(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/invoices/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating invoice: $e');
      return false;
    }
  }

  Future<bool> deleteInvoice(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/invoices/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting invoice: $e');
      return false;
    }
  }
}
