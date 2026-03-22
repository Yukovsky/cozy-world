/// Asset paths for additional photos in app_assets.
abstract class HistoryPhotoAssets {
  /// Get the path to an app photo by index (1-based).
  ///
  /// Example: getPhotoPath(1) returns 'packages/app_assets/photos/1.png'
  static String getPhotoPath(int index) => 'assets/photos/$index.png';

  /// Total number of photos available in this package.
  static const int totalPhotos = 10;
}
