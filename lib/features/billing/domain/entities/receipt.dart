import 'package:equatable/equatable.dart';

/// A single line on a receipt.
class ReceiptItem extends Equatable {
  final String name;
  final int quantity;
  final double price;
  final double total;

  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });

  @override
  List<Object?> get props => [name, quantity, price, total];
}

/// Everything required to print a receipt.
class ReceiptData extends Equatable {
  final String shopName;
  final String address1;
  final String address2;
  final String phone;
  final String footer;
  final List<ReceiptItem> items;
  final double total;

  const ReceiptData({
    required this.shopName,
    required this.address1,
    required this.address2,
    required this.phone,
    required this.footer,
    required this.items,
    required this.total,
  });

  @override
  List<Object?> get props =>
      [shopName, address1, address2, phone, footer, items, total];
}
