import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/app_message_keys.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/receipt.dart';
import '../../domain/usecases/billing_usecases.dart';

part 'billing_event.dart';
part 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final LookupProductByBarcodeUseCase lookupProductByBarcodeUseCase;
  final EnsurePrinterConnectedUseCase ensurePrinterConnectedUseCase;
  final PrintReceiptUseCase printReceiptUseCase;

  BillingBloc({
    required this.lookupProductByBarcodeUseCase,
    required this.ensurePrinterConnectedUseCase,
    required this.printReceiptUseCase,
  }) : super(const BillingState()) {
    on<ScanBarcodeEvent>(_onScanBarcode);
    on<AddProductToCartEvent>(_onAddProductToCart);
    on<RemoveProductFromCartEvent>(_onRemoveProductFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<PrintReceiptEvent>(_onPrintReceipt);
  }

  Future<void> _onScanBarcode(
      ScanBarcodeEvent event, Emitter<BillingState> emit) async {
    final result = await lookupProductByBarcodeUseCase(event.barcode);
    result.fold(
      (failure) => emit(state.copyWith(
          error: AppMessageKeys.withArg(
              AppMessageKeys.productNotFound, event.barcode))),
      (product) {
        add(AddProductToCartEvent(product));
      },
    );
  }

  void _onAddProductToCart(
      AddProductToCartEvent event, Emitter<BillingState> emit) {
    // Clear error when adding
    final cleanState = state.copyWith(error: null);

    final existingIndex = cleanState.cartItems
        .indexWhere((item) => item.product.id == event.product.id);
    if (existingIndex >= 0) {
      final existingItem = cleanState.cartItems[existingIndex];
      final backendItems = List<CartItem>.from(cleanState.cartItems);
      backendItems[existingIndex] =
          existingItem.copyWith(quantity: existingItem.quantity + 1);
      emit(cleanState.copyWith(cartItems: backendItems, error: null));
    } else {
      final newItem = CartItem(product: event.product);
      emit(cleanState.copyWith(
          cartItems: [...cleanState.cartItems, newItem], error: null));
    }
  }

  void _onRemoveProductFromCart(
      RemoveProductFromCartEvent event, Emitter<BillingState> emit) {
    final updatedList = state.cartItems
        .where((item) => item.product.id != event.productId)
        .toList();
    emit(state.copyWith(cartItems: updatedList));
  }

  void _onUpdateQuantity(
      UpdateQuantityEvent event, Emitter<BillingState> emit) {
    if (event.quantity <= 0) {
      add(RemoveProductFromCartEvent(event.productId));
      return;
    }

    final index = state.cartItems
        .indexWhere((item) => item.product.id == event.productId);
    if (index >= 0) {
      final items = List<CartItem>.from(state.cartItems);
      items[index] = items[index].copyWith(quantity: event.quantity);
      emit(state.copyWith(cartItems: items));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<BillingState> emit) {
    emit(const BillingState());
  }

  Future<void> _onPrintReceipt(
      PrintReceiptEvent event, Emitter<BillingState> emit) async {
    // Make sure a printer is reachable (auto-connect to the saved device).
    Failure? connectionFailure;
    final connection = await ensurePrinterConnectedUseCase(NoParams());
    connection.fold((failure) => connectionFailure = failure, (_) {});

    if (connectionFailure != null) {
      emit(state.copyWith(error: connectionFailure!.message, clearError: false));
      emit(state.copyWith(clearError: true));
      return;
    }

    emit(state.copyWith(
        isPrinting: true, printSuccess: false, clearError: true));

    final receipt = ReceiptData(
      shopName: event.shopName,
      address1: event.address1,
      address2: event.address2,
      phone: event.phone,
      footer: event.footer,
      total: state.totalAmount,
      items: state.cartItems
          .map((item) => ReceiptItem(
                name: item.product.name,
                quantity: item.quantity,
                price: item.product.price,
                total: item.total,
              ))
          .toList(),
    );

    final result = await printReceiptUseCase(receipt);
    result.fold(
      (failure) {
        emit(state.copyWith(
            isPrinting: false, error: failure.message, clearError: false));
        // Reset the transient error so it does not stay "sticky".
        emit(state.copyWith(clearError: true));
      },
      (_) => emit(state.copyWith(isPrinting: false, printSuccess: true)),
    );
  }
}
