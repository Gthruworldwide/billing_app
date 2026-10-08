import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product.dart';
import '../entities/receipt.dart';

/// Billing/checkout operations.
///
/// The presentation layer (BLoC) depends on this abstraction only, keeping it
/// free from infrastructure concerns such as Bluetooth or Hive.
abstract class BillingRepository {
  /// Looks up a product by its scanned barcode.
  Future<Either<Failure, Product>> getProductByBarcode(String barcode);

  /// Makes sure a thermal printer is available, connecting to the previously
  /// saved device when necessary.
  Future<Either<Failure, bool>> ensurePrinterConnected();

  /// Prints the given [receipt].
  Future<Either<Failure, void>> printReceipt(ReceiptData receipt);
}
