// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الفواتير';

  @override
  String get reviewOrder => 'مراجعة الطلب';

  @override
  String get cameraOffTitle => 'الكاميرا متوقفة';

  @override
  String get cameraOffBody =>
      'شغّل الكاميرا لبدء مسح الباركود وإضافة الأصناف تلقائياً.';

  @override
  String get turnOnCamera => 'تشغيل الكاميرا';

  @override
  String get scannedItems => 'الأصناف الممسوحة';

  @override
  String itemsTotalCount(int count) {
    return '$count أصناف';
  }

  @override
  String get totalPrice => 'الإجمالي';

  @override
  String get emptyCartTitle => 'القائمة فارغة';

  @override
  String get emptyCartBody => 'ستظهر الأصناف هنا عند مسحها بالكاميرا أعلاه.';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get printedSuccessfully => 'تمت الطباعة بنجاح';

  @override
  String get defaultShopName => 'المتجر';

  @override
  String get columnProductName => 'اسم المنتج';

  @override
  String get columnPrice => 'السعر';

  @override
  String get columnTotal => 'الإجمالي';

  @override
  String get scanToPay => 'امسح للدفع';

  @override
  String get grandTotal => 'الإجمالي الكلي';

  @override
  String get shopDetailsNotLoaded => 'لم يتم تحميل بيانات المتجر';

  @override
  String get printReceipt => 'طباعة الإيصال';

  @override
  String get scanBarcode => 'مسح الباركود';

  @override
  String get alignBarcodeInFrame => 'ضع الباركود داخل الإطار';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get defaultShopFallback => 'متجر التجزئة';

  @override
  String get managementSection => 'الإدارة';

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get productsSubtitle => 'إدارة المخزون والباركود';

  @override
  String get shopDetailsTitle => 'بيانات المتجر';

  @override
  String get shopDetailsSubtitle => 'تعديل بيانات النشاط والعنوان';

  @override
  String get hardwareSection => 'الأجهزة';

  @override
  String get connectedToPrinter => 'تم الاتصال بالطابعة';

  @override
  String get printDevice => 'جهاز الطباعة';

  @override
  String get printerConnected => 'الطابعة متصلة';

  @override
  String get noPrinterConnected => 'لا توجد طابعة متصلة';

  @override
  String get connectedBadge => 'متصل';

  @override
  String get printerConnectHelp =>
      'لتوصيل جهاز جديد، اضغط أيقونة الإعدادات للاقتران من بلوتوث الهاتف، ثم ارجع واضغط تحديث.';

  @override
  String get productManagement => 'إدارة المنتجات';

  @override
  String get scanOrEnterBarcode => 'امسح أو أدخل الباركود';

  @override
  String get tapIconToScan => 'اضغط الأيقونة لفتح ماسح الكاميرا';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String get noProductsFound => 'لا توجد منتجات. أضف منتجات جديدة.';

  @override
  String get noProductsMatchSearch => 'لا توجد منتجات مطابقة للبحث.';

  @override
  String get deleteProductTitle => 'حذف المنتج';

  @override
  String deleteProductConfirm(String name) {
    return 'هل تريد حذف $name؟';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get addProductTitle => 'إضافة منتج';

  @override
  String get barcodeLabel => 'الباركود';

  @override
  String get productNameLabel => 'اسم المنتج';

  @override
  String get priceLabel => 'السعر';

  @override
  String get productNameHint => 'مثال: أرز بسمتي';

  @override
  String get addProductButton => 'إضافة المنتج';

  @override
  String barcodeAlreadyExists(String barcode) {
    return 'يوجد منتج بنفس الباركود \"$barcode\" بالفعل.';
  }

  @override
  String get pleaseEnterBarcode => 'يرجى إدخال الباركود';

  @override
  String get pleaseEnterName => 'يرجى إدخال الاسم';

  @override
  String get pleaseEnterPrice => 'يرجى إدخال السعر';

  @override
  String get pleaseEnterValidNumber => 'يرجى إدخال رقم صحيح';

  @override
  String get priceCannotBeNegative => 'لا يمكن أن يكون السعر سالباً';

  @override
  String get editProductTitle => 'تعديل المنتج';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get generalInformation => 'بيانات عامة';

  @override
  String get shopDetailsHelp =>
      'ستظهر هذه البيانات على الإيصالات الرقمية والمطبوعة.';

  @override
  String get shopNameLabel => 'اسم المتجر';

  @override
  String get shopNameHint => 'مثال: سوبر ماركت النور';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get addressLine1Label => 'العنوان السطر الأول';

  @override
  String get addressLine1Hint => 'شارع التحرير، وسط البلد';

  @override
  String get addressLine2Label => 'العنوان السطر الثاني (اختياري)';

  @override
  String get addressLine2Hint => 'القاهرة - 11511';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get phoneNumberHint => '01012345678';

  @override
  String get upiIdLabel => 'معرّف الدفع';

  @override
  String get upiIdHint => 'wallet@bank';

  @override
  String get receiptFooterLabel => 'نص تذييل الإيصال';

  @override
  String get maxCharsHint => 'بحد أقصى 150 حرفاً';

  @override
  String get receiptFooterHint => 'شكراً لزيارتكم، نراكم قريباً';

  @override
  String get saveDetails => 'حفظ البيانات';

  @override
  String get shopDetailsSaved => 'تم حفظ بيانات المتجر';

  @override
  String productNotFound(String barcode) {
    return 'المنتج غير موجود: $barcode';
  }

  @override
  String get printerAutoConnectFailed => 'تعذر الاتصال التلقائي بالطابعة';

  @override
  String get printerNotConnected => 'الطابعة غير متصلة ولا توجد طابعة محفوظة';

  @override
  String printFailed(String details) {
    return 'فشلت الطباعة: $details';
  }

  @override
  String get productAddedSuccessfully => 'تمت إضافة المنتج بنجاح';

  @override
  String get productUpdatedSuccessfully => 'تم تحديث المنتج بنجاح';

  @override
  String get productDeletedSuccessfully => 'تم حذف المنتج بنجاح';

  @override
  String get noPairedDevices => 'لا توجد أجهزة مقترنة.';

  @override
  String get couldNotConnectPaired => 'تعذر الاتصال بأي جهاز مقترن.';

  @override
  String get failedConnectPrinter => 'فشل الاتصال بالطابعة';

  @override
  String get bluetoothPermissionDenied => 'تم رفض إذن البلوتوث';
}
