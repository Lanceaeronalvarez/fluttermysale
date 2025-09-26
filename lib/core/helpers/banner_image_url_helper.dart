class BannerImageUrlHelper {
  static String appendBannerSizeUrl(String? url, int width, int height, int resolutionOverride) {

    if (url != null) {
      String removedExtension = url.substring(0, url.lastIndexOf("."));
      String extension = "";

      int i = url.lastIndexOf('.');
      if (i > 0) {
        extension = url.substring(i + 1);
      }

      url = "${removedExtension}_${width}x${height}.${extension}";

      if (url.contains("?")) {
        url = "$url&width=$resolutionOverride";
      } else {
        url = "$url?width=$resolutionOverride";
      }
      return url;
    } else {
      return "";
    }
  }
}
