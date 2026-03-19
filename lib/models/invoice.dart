import 'customer.dart';

class Invoice {
  final int id;
  final int customerId;
  final double amount;
  final String status;
  final String? description;
  final Customer? customer;

  Invoice({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.status,
    this.description,
    this.customer,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    return Invoice(
      id: json['id'],
      customerId: json['customerId'] ?? customer?.id ?? 0,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      description: json['description'],
      customer: customer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'amount': amount,
      'status': status,
      'description': description,
    };
  }
}
