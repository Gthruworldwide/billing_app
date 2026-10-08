import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../constants/app_currency.dart';

/// Minimal ESC/POS command set used by [PrinterHelper].
class EscPos {
  static const List<int> init = [0x1B, 0x40];
  static const List<int> lineFeed = [0x0A];
}

/// Low level wrapper around the Bluetooth thermal printer.
///
/// Receipts are rendered to a monochrome bitmap and sent using the ESC/POS
/// raster command (`GS v 0`). Rendering through Flutter's text engine means
/// Arabic text is shaped and laid out (RTL) correctly regardless of the
/// printer's built-in code pages, which is why we do not rely on the
/// printer's font/encoding tables anymore.
class PrinterHelper {
  // Singleton
  static final PrinterHelper _instance = PrinterHelper._internal();
  factory PrinterHelper() => _instance;
  PrinterHelper._internal();

  /// Printable width in dots for a standard 58mm thermal printer.
  static const int printerWidth = 384;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> checkPermission() async {
    // Request Bluetooth and Location permissions
    // Android 12+ needs BLUETOOTH_SCAN, BLUETOOTH_CONNECT
    // Older Android needs BLUETOOTH, BLUETOOTH_ADMIN, ACCESS_FINE_LOCATION
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<List<BluetoothInfo>> getBondedDevices() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(String macAddress) async {
    try {
      final result =
          await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      _isConnected = result;
      return result;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {
      // Ignore: we always mark the connection as closed below.
    }
    _isConnected = false;
    return true;
  }

  /// Prints a simple text block (used by the printer test action).
  ///
  /// Returns `false` when the printer is not connected instead of failing
  /// silently.
  Future<bool> printText(String text) async {
    if (!_isConnected) return false;

    final specs = <_Spec>[
      for (final line in text.split('\n')) _CenterSpec(line, size: 22),
    ];
    await _printSpecs(specs);
    return true;
  }

  /// Prints a full receipt.
  ///
  /// Returns `false` when the printer is not connected.
  Future<bool> printReceipt({
    required String shopName,
    required String address1,
    required String address2,
    required String phone,
    required List<Map<String, dynamic>> items, // Name, Qty, Price, Total
    required double total,
    required String footer,
  }) async {
    if (!_isConnected) return false;

    final specs = <_Spec>[
      _CenterSpec(shopName, size: 30, weight: FontWeight.bold),
      for (final line in [address1, address2, phone])
        if (line.trim().isNotEmpty) _CenterSpec(line, size: 20),
      _CenterSpec(
        DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()),
        size: 20,
      ),
      const _DividerSpec(),
      const _SplitSpec(
        right: 'الصنف',
        left: 'الإجمالي',
        rightWeight: FontWeight.bold,
        leftWeight: FontWeight.bold,
      ),
      const _DividerSpec(),
      for (final item in items)
        _SplitSpec(
          right: '${item['qty']} × ${item['name']}',
          left: AppCurrency.amount((item['total'] as num?) ?? 0),
        ),
      const _DividerSpec(),
      _SplitSpec(
        right: 'الإجمالي الكلي',
        left: AppCurrency.amount(total),
        size: 24,
        rightWeight: FontWeight.bold,
        leftWeight: FontWeight.bold,
      ),
      if (footer.trim().isNotEmpty) ...[
        const _GapSpec(6),
        _CenterSpec(footer, size: 20),
      ],
    ];

    await _printSpecs(specs);
    return true;
  }

  Future<void> _printSpecs(List<_Spec> specs) async {
    final raster = await _renderToEscPos(specs);
    await _sendBytes(raster);
  }

  /// Renders [specs] into an ESC/POS byte stream.
  Future<List<int>> _renderToEscPos(List<_Spec> specs) async {
    const double padding = 10;
    const double gap = 6;
    const maxWidth = printerWidth - padding * 2;

    final lines = <_Line>[];
    double height = padding;
    for (final spec in specs) {
      final line = _buildLine(spec, maxWidth);
      lines.add(line);
      height += line.height + gap;
    }
    height += padding;

    final imageHeight = height.ceil();
    final width = printerWidth.toDouble();
    final canvasHeight = imageHeight.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width, canvasHeight),
    );
    final background = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, canvasHeight), background);

    double y = padding;
    for (final line in lines) {
      line.paint(canvas, y, printerWidth, padding);
      y += line.height + gap;
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(printerWidth, imageHeight);
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    picture.dispose();
    image.dispose();

    if (data == null) return const [];
    return _rasterize(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      printerWidth,
      imageHeight,
    );
  }

  _Line _buildLine(_Spec spec, double maxWidth) {
    switch (spec) {
      case _CenterSpec s:
        final painter =
            _painter(s.text, s.size, s.weight, maxWidth, ui.TextDirection.rtl);
        final x = padding + math.max(0, (maxWidth - painter.width) / 2);
        return _Line(
          items: [_PaintItem(painter, Offset(x, 0))],
          height: painter.height,
        );
      case _SplitSpec s:
        final amountWidth = maxWidth * 0.38;
        final nameWidth = maxWidth - amountWidth;
        final right =
            _painter(s.right, s.size, s.rightWeight, nameWidth, ui.TextDirection.rtl);
        final left =
            _painter(s.left, s.size, s.leftWeight, amountWidth, ui.TextDirection.ltr);
        return _Line(
          items: [
            _PaintItem(left, const Offset(padding, 0)),
            _PaintItem(
              right,
              Offset(padding + amountWidth + (nameWidth - right.width), 0),
            ),
          ],
          height: math.max(right.height, left.height),
        );
      case _DividerSpec _:
        return const _Line(divider: true, height: 10);
      case _GapSpec g:
        return _Line(height: g.height);
    }
  }

  TextPainter _painter(
    String text,
    double size,
    FontWeight weight,
    double maxWidth,
    ui.TextDirection direction,
  ) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFF000000),
          fontSize: size,
          fontWeight: weight,
        ),
      ),
      textDirection: direction,
      maxLines: 3,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
  }

  /// Converts raw RGBA pixels into an ESC/POS `GS v 0` raster command.
  List<int> _rasterize(Uint8List rgba, int width, int height) {
    final bytesPerRow = (width + 7) ~/ 8;
    final out = Uint8List(8 + bytesPerRow * height);

    // GS v 0 m xL xH yL yH
    out[0] = 0x1D;
    out[1] = 0x76;
    out[2] = 0x30;
    out[3] = 0x00;
    out[4] = bytesPerRow & 0xFF;
    out[5] = (bytesPerRow >> 8) & 0xFF;
    out[6] = height & 0xFF;
    out[7] = (height >> 8) & 0xFF;

    int offset = 8;
    for (int y = 0; y < height; y++) {
      final rowStart = y * width * 4;
      for (int byteIndex = 0; byteIndex < bytesPerRow; byteIndex++) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          final x = byteIndex * 8 + bit;
          if (x >= width) break;
          final index = rowStart + x * 4;
          final r = rgba[index];
          final g = rgba[index + 1];
          final b = rgba[index + 2];
          final a = rgba[index + 3];
          // Composite over a white background and convert to luminance.
          final luminance = ((r * 299 + g * 587 + b * 114) ~/ 1000) * a ~/ 255 +
              255 * (255 - a) ~/ 255;
          if (luminance < 128) byte |= 0x80 >> bit;
        }
        out[offset++] = byte;
      }
    }
    return out;
  }

  /// Sends bytes in small chunks to avoid overflowing the printer buffer.
  Future<void> _sendBytes(List<int> body) async {
    if (body.isEmpty) return;

    final payload = <int>[
      ...EscPos.init,
      ...body,
      ...EscPos.lineFeed,
      ...EscPos.lineFeed,
      ...EscPos.lineFeed,
    ];

    const chunkSize = 2048;
    for (int i = 0; i < payload.length; i += chunkSize) {
      final end = math.min(i + chunkSize, payload.length);
      await PrintBluetoothThermal.writeBytes(payload.sublist(i, end));
      await Future<void>.delayed(const Duration(milliseconds: 12));
    }
  }

  /// Horizontal padding (dots) used on the receipt bitmap.
  static const double padding = 10;
}

// ---------------------------------------------------------------------------
// Receipt layout model
// ---------------------------------------------------------------------------

sealed class _Spec {
  const _Spec();
}

class _CenterSpec extends _Spec {
  final String text;
  final double size;
  final FontWeight weight;
  const _CenterSpec(this.text, {this.size = 20, this.weight = FontWeight.normal});
}

class _SplitSpec extends _Spec {
  final String right;
  final String left;
  final double size;
  final FontWeight rightWeight;
  final FontWeight leftWeight;
  const _SplitSpec({
    required this.right,
    required this.left,
    this.size = 20,
    this.rightWeight = FontWeight.normal,
    this.leftWeight = FontWeight.normal,
  });
}

class _DividerSpec extends _Spec {
  const _DividerSpec();
}

class _GapSpec extends _Spec {
  final double height;
  const _GapSpec(this.height);
}

class _PaintItem {
  final TextPainter painter;
  final Offset offset;
  const _PaintItem(this.painter, this.offset);
}

class _Line {
  final List<_PaintItem> items;
  final bool divider;
  final double height;

  const _Line({this.items = const [], this.divider = false, required this.height});

  void paint(Canvas canvas, double y, int width, double padding) {
    if (divider) {
      final paint = Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(padding, y + height / 2),
        Offset(width - padding, y + height / 2),
        paint,
      );
      return;
    }

    for (final item in items) {
      item.painter.paint(canvas, item.offset + Offset(0, y));
    }
  }
}