import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../product/domain/entities/product.dart';
import '../entities/receipt.dart';
import '../repositories/billing_repository.dart';

class LookupProductByBarcodeUseCase implements UseCase<Product, String> {
  final BillingRepository repository;

  LookupProductByBarcodeUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(String params) {
    return repository.getProductByBarcode(params);
  }
}

class EnsurePrinterConnectedUseCase implements UseCase<bool, NoParams> {
  final BillingRepository repository;

  EnsurePrinterConnectedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.ensurePrinterConnected();
  }
}

class PrintReceiptUseCase implements UseCase<void, ReceiptData> {
  final BillingRepository repository;

  PrintReceiptUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReceiptData params) {
    return repository.printReceipt(params);
  }
}
