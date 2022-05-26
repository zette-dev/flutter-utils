import 'dart:io';

import 'package:dropsource_core/dropsource_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future makeCall(String phoneNumber) async {
  // Strips out extensions
  final _number = phoneNumber.split(', ').first;
  final url = 'tel:$_number';
  if (await canLaunchUrlString(url)) {
    return await launchUrlString(url);
  } else {
    print('Cannot make phone call: $phoneNumber');
    return null;
  }
}

Future sendText(String phoneNumber, {String? body}) async {
  // Strips out extensions
  var _number = "+1${numberValueAsString(phoneNumber.split(', ').first)}";

  // _number = Platform.isAndroid ? '+$_number' : _number;
  String url = 'sms:$_number';
  if (body != null && body.isNotEmpty) {
    url += '&body=${Uri.encodeComponent(body)}';
  }
  if (await canLaunchUrlString(url)) {
    return await launchUrlString(url);
  } else {
    print('Cannot send text: $phoneNumber');
    return null;
  }
}

Future openUrl(String url) async {
  if (await canLaunchUrlString(url)) {
    return await launchUrlString(url);
  } else {
    print('Cannot open url: $url');
    return null;
  }
}

Future sendEmail(String email,
    {String? subject, String? body, VoidCallback? onCantLaunch}) async {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body
    }),
  );

  if (await canLaunchUrlString(emailLaunchUri.toString())) {
    return launchUrlString(emailLaunchUri.toString());
  } else {
    onCantLaunch?.call();
  }
}

class DirectionsLauncher {
  DirectionsLauncher({this.lat, this.lng, this.address}) {
    if (hasCoordinates) {
      canLaunchUrlString(appleMapsUrl)
          .then((value) => _canOpenAppleMaps = value);
      canLaunchUrlString(googleMapsUrl)
          .then((value) => _canOpenGoogleMaps = value);
      canLaunchUrlString(wazeUrl).then((value) => _canOpenWazeMaps = value);
    }
  }
  final String? address;
  final double? lat, lng;
  bool get hasCoordinates => lat != null && lng != null;

  String get appleMapsUrl => 'https://maps.apple.com/?q=$lat,$lng';
  String get wazeUrl => 'https://waze.com/ul?ll=$lat,$lng&navigate=yes';
  String get googleMapsUrl => Platform.isIOS
      ? 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving'
      : 'google.navigation:q=$lat,$lng';

  bool _canOpenAppleMaps = false;
  bool get canOpenAppleMaps => _canOpenAppleMaps;
  bool _canOpenGoogleMaps = false;
  bool get canOpenGoogleMaps => _canOpenGoogleMaps;
  bool _canOpenWazeMaps = false;
  bool get canOpenWazeMaps => _canOpenWazeMaps;

  Future<bool> openAppleMaps() => launchUrlString(appleMapsUrl);
  Future<bool> openGoogleMaps() => launchUrlString(googleMapsUrl);
  Future<bool> openWazeMaps() => launchUrlString(wazeUrl);
}
