import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

Future<void> launchPhone(String url) async {
  if (!await urlLauncher.launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<bool> launchURL(BuildContext context, String url) async {
  try {
    await customTabs.launch(
      url,
      customTabsOption: customTabs.CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: customTabs.CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: customTabs.SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle:
            customTabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
