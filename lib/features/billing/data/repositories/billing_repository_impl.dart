import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/app_message_keys.dart';
import '../../../../core/utils/printer_helper.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../../settings/domain/repositories/printer_repository.dart';
import '../../domain/entities/receipt.dart';
import '../../domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  final ProductRepository _productRepository;
  final PrinterRepository _printerRepository;
  final PrinterHelper _printerHelper;

  BillingRepositoryImpl({
    required ProductRepository productRepository,
    required PrinterRepository printerRepository,
    PrinterHelper? printerHelper,
  })  : _productRepository = productRepository,
        _printerRepository = printerRepository,
        _printerHelper = printerHelper ?? PrinterHelper();

  @override
  Future<Either<Failure, Product>> getProductByBarcode(String barcode) {
    return _productRepository.getProductByBarcode(barcode);
  }

  @override
  Future<Either<Failure, bool>> ensurePrinterConnected() async {
    if (_printerHelper.isConnected) return const Right(true);

    final mac = _printerRepository.getSavedPrinterMac();
    if (mac == null || mac.isEmpty) {
      return const Left(CacheFailure(AppMessageKeys.printerNotConnected));
    }

    final connected = await _printerRepository.connect(mac);
    if (!connected) {
      return const Left(CacheFailure(AppMessageKeys.printerAutoConnectFailed));
    }
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> printReceipt(ReceiptData receipt) async {
    try {
      final items = receipt.items
          .map((item) => {
                'name': item.name,
                'qty': item.quantity,
                'price': item.price,
                'total': item.total,
              })
          .toList();

      final printed = await _printerHelper.printReceipt(
        shopName: receipt.shopName,
        address1: receipt.address1,
        address2: receipt.address2,
        phone: receipt.phone,
        items: items,
        total: receipt.total,
        footer: receipt.footer,
      );

      if (!printed) {
        return const Left(CacheFailure(AppMessageKeys.printerNotConnected));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(AppMessageKeys.withArg(AppMessageKeys.printFailed, '$e')),
      );
    }
  }
}
