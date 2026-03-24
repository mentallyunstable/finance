import 'package:core/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  const UrlLauncherService();

  void launch(String url, {LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      }
    } catch (exception, stackTrace) {
      logger.error('Can\'t launch provided url - "$url"', exception: exception, stackTrace: stackTrace);
    }
  }

  void launchUri(Uri uri, {LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      }
    } catch (exception, stackTrace) {
      logger.error('Can\'t launch provided url - "$uri"', exception: exception, stackTrace: stackTrace);
    }
  }
}
