import 'package:flutter/foundation.dart';

/// In-memory ring buffer for on-device debug logs.
///
/// Any layer (Core, Feature) can write to this buffer via [log].
/// The [DebugLogOverlay] widget reads it via [lines] ValueNotifier
/// and displays entries live on screen — no connected computer required.
///
/// • Lives in Core so every feature can reuse it.
/// • Only active in non-Release builds ([kReleaseMode] guard in main.dart).
/// • Thread-safe for single-isolate Flutter apps (all UI work is on main).
class DebugLogBuffer {
  DebugLogBuffer._();

  static final DebugLogBuffer instance = DebugLogBuffer._();

  /// Maximum number of log lines kept in memory (ring-buffer behaviour).
  static const int _maxLines = 500;

  /// Notifier consumed by [DebugLogOverlay].
  final ValueNotifier<List<String>> lines =
      ValueNotifier<List<String>>([]);

  /// Wall-clock stopwatch started when the singleton is created.
  final Stopwatch _sw = Stopwatch()..start();

  /// Write a timestamped entry.
  ///
  /// [tag] — short category label, e.g. `'PDF'`, `'Download'`.
  /// [message] — free-form description of the event.
  void log(String tag, String message) {
    if (kReleaseMode) return; // zero overhead in production
    final ts = (_sw.elapsedMilliseconds / 1000).toStringAsFixed(2);
    final entry = '[$ts s][$tag] $message';
    debugPrint(entry); // also goes to adb logcat when device is connected
    final updated = List<String>.from(lines.value)..add(entry);
    if (updated.length > _maxLines) updated.removeAt(0);
    lines.value = updated;
  }

  /// Remove all buffered entries.
  void clear() => lines.value = [];

  /// Produce a single string suitable for clipboard sharing.
  String exportAsText() => lines.value.join('\n');
}
