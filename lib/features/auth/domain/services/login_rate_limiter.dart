class LoginAttemptResult {
  final bool isAllowed;
  final Duration? lockDuration;

  const LoginAttemptResult._({required this.isAllowed, this.lockDuration});

  factory LoginAttemptResult.allowed() =>
      const LoginAttemptResult._(isAllowed: true);

  factory LoginAttemptResult.locked(Duration duration) =>
      LoginAttemptResult._(isAllowed: false, lockDuration: duration);

  String get lockMessage {
    if (lockDuration == null) return '';
    final minutes = lockDuration!.inMinutes;
    final seconds = lockDuration!.inSeconds % 60;
    return 'حاول مرة أخرى بعد $minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class LoginRateLimiter {
  static const _maxAttempts = 5;
  static const _lockDuration = Duration(minutes: 15);

  int _failedAttempts = 0;
  DateTime? _lockUntil;

  LoginAttemptResult canAttempt() {
    if (_lockUntil != null && DateTime.now().isBefore(_lockUntil!)) {
      final remaining = _lockUntil!.difference(DateTime.now());
      return LoginAttemptResult.locked(remaining);
    }

    if (_failedAttempts >= _maxAttempts) {
      _lockUntil = DateTime.now().add(_lockDuration);
      _failedAttempts = 0;
      return LoginAttemptResult.locked(_lockDuration);
    }

    return LoginAttemptResult.allowed();
  }

  void recordFailure() => _failedAttempts++;

  void recordSuccess() {
    _failedAttempts = 0;
    _lockUntil = null;
  }

  int get remainingAttempts => _maxAttempts - _failedAttempts;
}
