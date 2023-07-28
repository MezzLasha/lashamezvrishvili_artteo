import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> launchPhone(String url) async {
  if (!await url_launcher.launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<bool> launchURL(BuildContext context, String url) async {
  try {
    await custom_tabs.launch(
      url,
      customTabsOption: custom_tabs.CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: custom_tabs.CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: custom_tabs.SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle:
            custom_tabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
