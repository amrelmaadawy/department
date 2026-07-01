class InputSanitizer {
  // ===== HTML / XSS Protection =====
  static String sanitizeHtml(String input) {
    return input
        .replaceAll('<script', '&lt;script')
        .replaceAll('</script>', '&lt;/script&gt;')
        .replaceAll('javascript:', '')
        .replaceAll('vbscript:', '')
        .replaceAll('onerror=', '')
        .replaceAll('onload=', '')
        .replaceAll('onclick=', '')
        .replaceAll('onmouseover=', '');
  }

  // ===== Field Validation =====
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(email.trim());
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(
      phone.replaceAll(RegExp(r'[\s\-()]'), ''),
    );
  }

  static bool isValidName(String name) {
    return RegExp(r'^[\u0600-\u06FFa-zA-Z\s]{2,100}$').hasMatch(name.trim());
  }

  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  // ===== SQL Injection Prevention =====
  static String escapeSql(String input) {
    return input
        .replaceAll("'", "''")
        .replaceAll(';', '')
        .replaceAll('--', '')
        .replaceAll('/*', '')
        .replaceAll('*/', '');
  }

  // ===== General Sanitization =====
  static String normalize(String input) => input.trim();

  static String truncate(String input, {int maxLength = 500}) {
    return input.length > maxLength ? input.substring(0, maxLength) : input;
  }
}
