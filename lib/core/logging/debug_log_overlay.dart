import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'debug_log_buffer.dart';

/// Floating draggable on-device log console.
///
/// Wrap your [MaterialApp]'s `builder` with this widget in Debug/Staging
/// only. A small bug icon bubble appears on screen; tapping it expands
/// a dark terminal-style panel showing live [DebugLogBuffer] entries with
/// copy and clear controls.
///
/// Usage in main.dart:
/// ```dart
/// builder: (context, child) {
///   Widget result = child!;
///   if (!kReleaseMode) result = DebugLogOverlay(child: result);
///   return result;
/// }
/// ```
class DebugLogOverlay extends StatefulWidget {
  final Widget child;
  const DebugLogOverlay({super.key, required this.child});

  @override
  State<DebugLogOverlay> createState() => _DebugLogOverlayState();
}

class _DebugLogOverlayState extends State<DebugLogOverlay> {
  bool _expanded = false;
  Offset _position = const Offset(16, 120);

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (d) =>
                setState(() => _position += d.delta),
            child: _expanded
                ? _ConsolePanel(onClose: () => setState(() => _expanded = false))
                : _BubbleButton(onTap: () => setState(() => _expanded = true)),
          ),
        ),
      ],
    );
  }
}

// ── Collapsed bubble ────────────────────────────────────────────────────────

class _BubbleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BubbleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<List<String>>(
        valueListenable: DebugLogBuffer.instance.lines,
        builder: (_, logs, _) => Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: logs.isEmpty ? Colors.grey : Colors.greenAccent,
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.bug_report_rounded,
            color: logs.isEmpty ? Colors.grey : Colors.greenAccent,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ── Expanded console panel ──────────────────────────────────────────────────

class _ConsolePanel extends StatelessWidget {
  final VoidCallback onClose;
  const _ConsolePanel({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 340,
        height: 420,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 4),
            Expanded(child: _buildLogList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 14),
        const SizedBox(width: 6),
        const Text(
          'Debug Logs',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const Spacer(),
        _HeaderButton(
          icon: Icons.copy_rounded,
          onPressed: () => Clipboard.setData(
            ClipboardData(text: DebugLogBuffer.instance.exportAsText()),
          ),
        ),
        _HeaderButton(
          icon: Icons.delete_outline_rounded,
          onPressed: DebugLogBuffer.instance.clear,
        ),
        _HeaderButton(
          icon: Icons.close_rounded,
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildLogList() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: DebugLogBuffer.instance.lines,
      builder: (_, logs, _) {
        if (logs.isEmpty) {
          return const Center(
            child: Text(
              'No logs yet.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: logs.length,
          itemBuilder: (_, i) {
            final line = logs[logs.length - 1 - i];
            final isError = line.toLowerCase().contains('error') ||
                line.toLowerCase().contains('failed') ||
                line.toLowerCase().contains('✗');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                line,
                style: TextStyle(
                  color: isError ? Colors.redAccent : Colors.greenAccent,
                  fontSize: 9.5,
                  fontFamily: 'monospace',
                  height: 1.35,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }
}
