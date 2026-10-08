import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الفواتير'**
  String get appTitle;

  /// No description provided for @reviewOrder.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الطلب'**
  String get reviewOrder;

  /// No description provided for @cameraOffTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا متوقفة'**
  String get cameraOffTitle;

  /// No description provided for @cameraOffBody.
  ///
  /// In ar, this message translates to:
  /// **'شغّل الكاميرا لبدء مسح الباركود وإضافة الأصناف تلقائياً.'**
  String get cameraOffBody;

  /// No description provided for @turnOnCamera.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الكاميرا'**
  String get turnOnCamera;

  /// No description provided for @scannedItems.
  ///
  /// In ar, this message translates to:
  /// **'الأصناف الممسوحة'**
  String get scannedItems;

  /// No description provided for @itemsTotalCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} أصناف'**
  String itemsTotalCount(int count);

  /// No description provided for @totalPrice.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get totalPrice;

  /// No description provided for @emptyCartTitle.
  ///
  /// In ar, this message translates to:
  /// **'القائمة فارغة'**
  String get emptyCartTitle;

  /// No description provided for @emptyCartBody.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر الأصناف هنا عند مسحها بالكاميرا أعلاه.'**
  String get emptyCartBody;

  /// No description provided for @checkoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get checkoutTitle;

  /// No description provided for @printedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تمت الطباعة بنجاح'**
  String get printedSuccessfully;

  /// No description provided for @defaultShopName.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get defaultShopName;

  /// No description provided for @columnProductName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج'**
  String get columnProductName;

  /// No description provided for @columnPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get columnPrice;

  /// No description provided for @columnTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get columnTotal;

  /// No description provided for @scanToPay.
  ///
  /// In ar, this message translates to:
  /// **'امسح للدفع'**
  String get scanToPay;

  /// No description provided for @grandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي الكلي'**
  String get grandTotal;

  /// No description provided for @shopDetailsNotLoaded.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تحميل بيانات المتجر'**
  String get shopDetailsNotLoaded;

  /// No description provided for @printReceipt.
  ///
  /// In ar, this message translates to:
  /// **'طباعة الإيصال'**
  String get printReceipt;

  /// No description provided for @scanBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح الباركود'**
  String get scanBarcode;

  /// No description provided for @alignBarcodeInFrame.
  ///
  /// In ar, this message translates to:
  /// **'ضع الباركود داخل الإطار'**
  String get alignBarcodeInFrame;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @defaultShopFallback.
  ///
  /// In ar, this message translates to:
  /// **'متجر التجزئة'**
  String get defaultShopFallback;

  /// No description provided for @managementSection.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة'**
  String get managementSection;

  /// No description provided for @productsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get productsTitle;

  /// No description provided for @productsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المخزون والباركود'**
  String get productsSubtitle;

  /// No description provided for @shopDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المتجر'**
  String get shopDetailsTitle;

  /// No description provided for @shopDetailsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات النشاط والعنوان'**
  String get shopDetailsSubtitle;

  /// No description provided for @hardwareSection.
  ///
  /// In ar, this message translates to:
  /// **'الأجهزة'**
  String get hardwareSection;

  /// No description provided for @connectedToPrinter.
  ///
  /// In ar, this message translates to:
  /// **'تم الاتصال بالطابعة'**
  String get connectedToPrinter;

  /// No description provided for @printDevice.
  ///
  /// In ar, this message translates to:
  /// **'جهاز الطباعة'**
  String get printDevice;

  /// No description provided for @printerConnected.
  ///
  /// In ar, this message translates to:
  /// **'الطابعة متصلة'**
  String get printerConnected;

  /// No description provided for @noPrinterConnected.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طابعة متصلة'**
  String get noPrinterConnected;

  /// No description provided for @connectedBadge.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get connectedBadge;

  /// No description provided for @printerConnectHelp.
  ///
  /// In ar, this message translates to:
  /// **'لتوصيل جهاز جديد، اضغط أيقونة الإعدادات للاقتران من بلوتوث الهاتف، ثم ارجع واضغط تحديث.'**
  String get printerConnectHelp;

  /// No description provided for @productManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المنتجات'**
  String get productManagement;

  /// No description provided for @scanOrEnterBarcode.
  ///
  /// In ar, this message translates to:
  /// **'امسح أو أدخل الباركود'**
  String get scanOrEnterBarcode;

  /// No description provided for @tapIconToScan.
  ///
  /// In ar, this message translates to:
  /// **'اضغط الأيقونة لفتح ماسح الكاميرا'**
  String get tapIconToScan;

  /// No description provided for @errorPrefix.
  ///
  /// In ar, this message translates to:
  /// **'خطأ: {message}'**
  String errorPrefix(String message);

  /// No description provided for @noProductsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات. أضف منتجات جديدة.'**
  String get noProductsFound;

  /// No description provided for @noProductsMatchSearch.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات مطابقة للبحث.'**
  String get noProductsMatchSearch;

  /// No description provided for @deleteProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف المنتج'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف {name}؟'**
  String deleteProductConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @addProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة منتج'**
  String get addProductTitle;

  /// No description provided for @barcodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الباركود'**
  String get barcodeLabel;

  /// No description provided for @productNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج'**
  String get productNameLabel;

  /// No description provided for @priceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get priceLabel;

  /// No description provided for @productNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: أرز بسمتي'**
  String get productNameHint;

  /// No description provided for @addProductButton.
  ///
  /// In ar, this message translates to:
  /// **'إضافة المنتج'**
  String get addProductButton;

  /// No description provided for @barcodeAlreadyExists.
  ///
  /// In ar, this message translates to:
  /// **'يوجد منتج بنفس الباركود \"{barcode}\" بالفعل.'**
  String barcodeAlreadyExists(String barcode);

  /// No description provided for @pleaseEnterBarcode.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الباركود'**
  String get pleaseEnterBarcode;

  /// No description provided for @pleaseEnterName.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الاسم'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال السعر'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم صحيح'**
  String get pleaseEnterValidNumber;

  /// No description provided for @priceCannotBeNegative.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن أن يكون السعر سالباً'**
  String get priceCannotBeNegative;

  /// No description provided for @editProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المنتج'**
  String get editProductTitle;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @generalInformation.
  ///
  /// In ar, this message translates to:
  /// **'بيانات عامة'**
  String get generalInformation;

  /// No description provided for @shopDetailsHelp.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هذه البيانات على الإيصالات الرقمية والمطبوعة.'**
  String get shopDetailsHelp;

  /// No description provided for @shopNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get shopNameLabel;

  /// No description provided for @shopNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: سوبر ماركت النور'**
  String get shopNameHint;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get requiredField;

  /// No description provided for @addressLine1Label.
  ///
  /// In ar, this message translates to:
  /// **'العنوان السطر الأول'**
  String get addressLine1Label;

  /// No description provided for @addressLine1Hint.
  ///
  /// In ar, this message translates to:
  /// **'شارع التحرير، وسط البلد'**
  String get addressLine1Hint;

  /// No description provided for @addressLine2Label.
  ///
  /// In ar, this message translates to:
  /// **'العنوان السطر الثاني (اختياري)'**
  String get addressLine2Label;

  /// No description provided for @addressLine2Hint.
  ///
  /// In ar, this message translates to:
  /// **'القاهرة - 11511'**
  String get addressLine2Hint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'01012345678'**
  String get phoneNumberHint;

  /// No description provided for @upiIdLabel.
  ///
  /// In ar, this message translates to:
  /// **'معرّف الدفع'**
  String get upiIdLabel;

  /// No description provided for @upiIdHint.
  ///
  /// In ar, this message translates to:
  /// **'wallet@bank'**
  String get upiIdHint;

  /// No description provided for @receiptFooterLabel.
  ///
  /// In ar, this message translates to:
  /// **'نص تذييل الإيصال'**
  String get receiptFooterLabel;

  /// No description provided for @maxCharsHint.
  ///
  /// In ar, this message translates to:
  /// **'بحد أقصى 150 حرفاً'**
  String get maxCharsHint;

  /// No description provided for @receiptFooterHint.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لزيارتكم، نراكم قريباً'**
  String get receiptFooterHint;

  /// No description provided for @saveDetails.
  ///
  /// In ar, this message translates to:
  /// **'حفظ البيانات'**
  String get saveDetails;

  /// No description provided for @shopDetailsSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ بيانات المتجر'**
  String get shopDetailsSaved;

  /// No description provided for @productNotFound.
  ///
  /// In ar, this message translates to:
  /// **'المنتج غير موجود: {barcode}'**
  String productNotFound(String barcode);

  /// No description provided for @printerAutoConnectFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال التلقائي بالطابعة'**
  String get printerAutoConnectFailed;

  /// No description provided for @printerNotConnected.
  ///
  /// In ar, this message translates to:
  /// **'الطابعة غير متصلة ولا توجد طابعة محفوظة'**
  String get printerNotConnected;

  /// No description provided for @printFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشلت الطباعة: {details}'**
  String printFailed(String details);

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المنتج بنجاح'**
  String get productAddedSuccessfully;

  /// No description provided for @productUpdatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المنتج بنجاح'**
  String get productUpdatedSuccessfully;

  /// No description provided for @productDeletedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المنتج بنجاح'**
  String get productDeletedSuccessfully;

  /// No description provided for @noPairedDevices.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أجهزة مقترنة.'**
  String get noPairedDevices;

  /// No description provided for @couldNotConnectPaired.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بأي جهاز مقترن.'**
  String get couldNotConnectPaired;

  /// No description provided for @failedConnectPrinter.
  ///
  /// In ar, this message translates to:
  /// **'فشل الاتصال بالطابعة'**
  String get failedConnectPrinter;

  /// No description provided for @bluetoothPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض إذن البلوتوث'**
  String get bluetoothPermissionDenied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
