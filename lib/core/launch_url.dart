import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';

void launchWithURL({required String url}) async {
  final uri = Uri.parse(url);
  final canLaunch = await canLaunchUrl(uri);
  var eventName = url.contains("demoo")
          ? AnalyticsEvents.openDemo.name
          : AnalyticsEvents.launchUrl.name;
  if (canLaunch) {
    await launchUrl(uri);
    await serviceLocator<Analytics>().logEvent(eventName, parameters: {
      AnalyticsEventParameter.link.name: url,
      AnalyticsEventParameter.status.name: true,
    });
  } else {
    await serviceLocator<Analytics>().logEvent(eventName, parameters: {
      AnalyticsEventParameter.link.name: url,
      AnalyticsEventParameter.status.name: false,
      AnalyticsEventParameter.error.name: 'Could not launch $url',
    });
    throw 'Could not launch $url';
  }
}
