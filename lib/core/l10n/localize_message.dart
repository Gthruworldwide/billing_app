import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

import 'app_message_keys.dart';

String localizeMessage(BuildContext context, String raw) {
  final l10n = AppLocalizations.of(context);
  final (key, arg) = AppMessageKeys.parse(raw);

  switch (key) {
    case AppMessageKeys.productNotFound:
      return l10n.productNotFound(arg ?? '');
    case AppMessageKeys.quantityExceedsStock:
      return l10n.quantityExceedsStock(int.tryParse(arg ?? '') ?? 0);
    case AppMessageKeys.printerAutoConnectFailed:
      return l10n.printerAutoConnectFailed;
    case AppMessageKeys.printerNotConnected:
      return l10n.printerNotConnected;
    case AppMessageKeys.printFailed:
      return l10n.printFailed(arg ?? '');
    case AppMessageKeys.productAddedSuccessfully:
      return l10n.productAddedSuccessfully;
    case AppMessageKeys.productUpdatedSuccessfully:
      return l10n.productUpdatedSuccessfully;
    case AppMessageKeys.productDeletedSuccessfully:
      return l10n.productDeletedSuccessfully;
    case AppMessageKeys.noPairedDevices:
      return l10n.noPairedDevices;
    case AppMessageKeys.couldNotConnectPaired:
      return l10n.couldNotConnectPaired;
    case AppMessageKeys.failedConnectPrinter:
      return l10n.failedConnectPrinter;
    case AppMessageKeys.bluetoothPermissionDenied:
      return l10n.bluetoothPermissionDenied;
    default:
      return raw;
  }
}
