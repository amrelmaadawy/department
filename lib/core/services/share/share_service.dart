abstract class IShareService {
  /// Shares an image with accompanying text.
  /// If the imagePath is a network URL (starts with http), it will be downloaded first.
  /// If the imagePath is empty, it will throw an exception or handle gracefully.
  Future<void> shareImage({required String imagePath, required String text});
}
