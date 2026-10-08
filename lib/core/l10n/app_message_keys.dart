class AppMessageKeys {
  static const productNotFound = 'productNotFound';
  static const printerAutoConnectFailed = 'printerAutoConnectFailed';
  static const printerNotConnected = 'printerNotConnected';
  static const printFailed = 'printFailed';
  static const productAddedSuccessfully = 'productAddedSuccessfully';
  static const productUpdatedSuccessfully = 'productUpdatedSuccessfully';
  static const productDeletedSuccessfully = 'productDeletedSuccessfully';
  static const noPairedDevices = 'noPairedDevices';
  static const couldNotConnectPaired = 'couldNotConnectPaired';
  static const failedConnectPrinter = 'failedConnectPrinter';
  static const bluetoothPermissionDenied = 'bluetoothPermissionDenied';

  static String withArg(String key, String arg) => '$key|$arg';

  static (String key, String? arg) parse(String raw) {
    final separator = raw.indexOf('|');
    if (separator < 0) {
      return (raw, null);
    }
    return (raw.substring(0, separator), raw.substring(separator + 1));
  }
}
