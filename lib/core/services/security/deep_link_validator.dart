class DeepLinkValidator {
  static const _allowedHosts = <String>{
    'moqlate.coderaeg.com',
    'staging.moqlate.coderaeg.com',
    'dev.moqlate.coderaeg.com',
    'coderaeg.com',
    'shatebha.com',
  };

  static const _allowedSchemes = <String>{
    'https',
    'http',
    'apartment',
    'shatebha',
  };

  static bool isValid(Uri uri) {
    if (!_allowedSchemes.contains(uri.scheme)) return false;
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      if (!_allowedHosts.contains(uri.host)) return false;
    }
    if (uri.queryParameters.containsKey('redirect_url')) return false;
    if (uri.queryParameters.containsKey('redirect')) return false;
    if (uri.queryParameters.containsKey('next')) return false;
    return true;
  }

  static Uri? sanitize(String rawUrl) {
    try {
      final uri = Uri.parse(rawUrl);
      if (!isValid(uri)) return null;
      return uri;
    } catch (_) {
      return null;
    }
  }
}
