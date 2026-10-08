import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:billing_app/core/error/failure.dart';
import 'package:billing_app/features/billing/domain/entities/receipt.dart';
import 'package:billing_app/features/billing/domain/repositories/billing_repository.dart';
import 'package:billing_app/features/billing/domain/usecases/billing_usecases.dart';
import 'package:billing_app/features/billing/presentation/bloc/billing_bloc.dart';
import 'package:billing_app/features/product/domain/entities/product.dart';

class _FakeBillingRepository implements BillingRepository {
  Product? lookupResult;
  bool printerReady = true;
  bool printSucceeds = true;
  ReceiptData? lastReceipt;

  @override
  Future<Either<Failure, Product>> getProductByBarcode(String barcode) async {
    final product = lookupResult;
    if (product == null) {
      return const Left(CacheFailure('not found'));
    }
    return Right(product);
  }

  @override
  Future<Either<Failure, bool>> ensurePrinterConnected() async {
    if (!printerReady) {
      return const Left(CacheFailure('no printer'));
    }
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> printReceipt(ReceiptData receipt) async {
    lastReceipt = receipt;
    if (!printSucceeds) {
      return const Left(CacheFailure('print failed'));
    }
    return const Right(null);
  }
}

void main() {
  const product = Product(id: '1', name: 'ماء', barcode: '111', price: 10.0);
  late _FakeBillingRepository repository;
  late BillingBloc bloc;

  setUp(() {
    repository = _FakeBillingRepository();
    bloc = BillingBloc(
      lookupProductByBarcodeUseCase: LookupProductByBarcodeUseCase(repository),
      ensurePrinterConnectedUseCase: EnsurePrinterConnectedUseCase(repository),
      printReceiptUseCase: PrintReceiptUseCase(repository),
    );
  });

  tearDown(() => bloc.close());

  Future<BillingState> awaitState(
      bool Function(BillingState state) predicate) {
    return bloc.stream.firstWhere(predicate);
  }

  test('adding the same product twice merges the quantity', () async {
    bloc.add(const AddProductToCartEvent(product));
    await awaitState((s) => s.cartItems.length == 1);

    bloc.add(const AddProductToCartEvent(product));
    final state = await awaitState((s) => s.cartItems.first.quantity == 2);

    expect(state.cartItems, hasLength(1));
    expect(state.cartItems.first.quantity, 2);
    expect(state.totalAmount, 20.0);
  });

  test('updating quantity to zero removes the item from the cart', () async {
    bloc.add(const AddProductToCartEvent(product));
    await awaitState((s) => s.cartItems.length == 1);

    bloc.add(UpdateQuantityEvent(product.id, 0));
    final state = await awaitState((s) => s.cartItems.isEmpty);

    expect(state.totalAmount, 0.0);
  });

  test('adding more than the tracked stock emits an error', () async {
    const tracked =
        Product(id: '2', name: 'أرز', barcode: '222', price: 5.0, stock: 3);

    bloc.add(const AddProductToCartEvent(tracked));
    bloc.add(const AddProductToCartEvent(tracked));
    bloc.add(const AddProductToCartEvent(tracked));
    await awaitState((s) => s.cartItems.first.quantity == 3);

    bloc.add(const AddProductToCartEvent(tracked));
    final error = await awaitState((s) => s.error != null);

    // The cart must not change when the requested quantity exceeds stock.
    expect(error.cartItems.first.quantity, 3);
    expect(error.cartItems.first.product.stock, 3);
  });

  test('updating quantity beyond the tracked stock emits an error', () async {
    const tracked =
        Product(id: '3', name: 'شاي', barcode: '333', price: 7.0, stock: 2);

    bloc.add(const AddProductToCartEvent(tracked));
    await awaitState((s) => s.cartItems.isNotEmpty);

    bloc.add(UpdateQuantityEvent(tracked.id, 5));
    final error = await awaitState((s) => s.error != null);

    expect(error.cartItems.first.quantity, 1);
  });

  test('scanning an existing barcode adds the product to the cart', () async {
    repository.lookupResult = product;

    bloc.add(const ScanBarcodeEvent('111'));
    final state = await awaitState((s) => s.cartItems.isNotEmpty);

    expect(state.cartItems.first.product.name, 'ماء');
    expect(state.cartItems.first.quantity, 1);
  });

  test('scanning an unknown barcode emits an error', () async {
    repository.lookupResult = null;

    bloc.add(const ScanBarcodeEvent('999'));
    final state = await awaitState((s) => s.error != null);

    expect(state.cartItems, isEmpty);
  });

  test('printing a receipt emits printSuccess and builds receipt data',
      () async {
    bloc.add(const AddProductToCartEvent(product));
    bloc.add(const AddProductToCartEvent(product));
    await awaitState((s) => s.cartItems.first.quantity == 2);

    bloc.add(const PrintReceiptEvent(
      shopName: 'متجري',
      address1: 'شارع 1',
      address2: 'مدينة',
      phone: '01000000000',
      footer: 'شكراً لزيارتكم',
    ));

    final state = await awaitState((s) => s.printSuccess);

    expect(state.isPrinting, false);
    expect(repository.lastReceipt, isNotNull);
    expect(repository.lastReceipt!.total, 20.0);
    expect(repository.lastReceipt!.items, hasLength(1));
    expect(repository.lastReceipt!.items.first.quantity, 2);
    expect(repository.lastReceipt!.shopName, 'متجري');
  });

  test('printing without a connected printer emits an error', () async {
    repository.printerReady = false;
    bloc.add(const AddProductToCartEvent(product));
    await awaitState((s) => s.cartItems.isNotEmpty);

    bloc.add(const PrintReceiptEvent(
      shopName: 'متجري',
      address1: '',
      address2: '',
      phone: '',
      footer: '',
    ));

    final state = await awaitState((s) => s.error != null);

    expect(state.printSuccess, false);
    expect(state.isPrinting, false);
  });
}