import 'package:vibration/vibration.dart';

/// Vibrates the device on a successful barcode read.
///
/// Shared by every scanner surface so the behaviour (and the permission check
/// around it) is defined in one place.
Future<void> vibrateOnce() async {
  final hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator == true) {
    Vibration.vibrate();
  }
}