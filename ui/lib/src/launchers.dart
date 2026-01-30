import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zette_ui/src/formatters.dart';
import 'package:zette_utils/zette_utils.dart' show logger;

Future makeCall(String phoneNumber) async {
  // Strips out extensions
  final _number = phoneNumber.split(', ').first;
  final url = 'tel:$_number';
  if (await canLaunchUrlString(url)) {
    return await launchUrlString(url);
  }
  logger.i('Cannot make phone call: $phoneNumber');
  return null;
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
  }
  logger.i('Cannot send text: $phoneNumber');
  return null;
}

Future openUrl(String url) async {
  if (await canLaunchUrlString(url)) {
    return await launchUrlString(url);
  }
  logger.i('Cannot open url: $url');
  return null;
}

Future sendEmail(
  String email, {
  String? subject,
  String? body,
  VoidCallback? onCantLaunch,
}) async {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
    }),
  );

  if (await canLaunchUrlString(emailLaunchUri.toString())) {
    return launchUrlString(emailLaunchUri.toString());
  } else {
    onCantLaunch?.call();
  }
}

class DirectionsLauncher {
  DirectionsLauncher._({
    this.lat,
    this.lng,
    this.address,
    required this.canOpenAppleMaps,
    required this.canOpenGoogleMaps,
    required this.canOpenWazeMaps,
  });

  final String? address;
  final double? lat, lng;
  final bool canOpenAppleMaps;
  final bool canOpenGoogleMaps;
  final bool canOpenWazeMaps;

  bool get hasCoordinates => lat != null && lng != null;

  String get appleMapsUrl => 'https://maps.apple.com/?q=$lat,$lng';
  String get wazeUrl => 'https://waze.com/ul?ll=$lat,$lng&navigate=yes';
  String get googleMapsUrl => Platform.isIOS
      ? 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving'
      : 'google.navigation:q=$lat,$lng';

  static Future<DirectionsLauncher> create({
    double? lat,
    double? lng,
    String? address,
  }) async {
    final hasCoordinates = lat != null && lng != null;
    final appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';
    final wazeUrl = 'https://waze.com/ul?ll=$lat,$lng&navigate=yes';
    final googleMapsUrl = Platform.isIOS
        ? 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving'
        : 'google.navigation:q=$lat,$lng';

    final results = hasCoordinates
        ? await Future.wait([
            canLaunchUrlString(appleMapsUrl),
            canLaunchUrlString(googleMapsUrl),
            canLaunchUrlString(wazeUrl),
          ])
        : [false, false, false];

    return DirectionsLauncher._(
      lat: lat,
      lng: lng,
      address: address,
      canOpenAppleMaps: results[0],
      canOpenGoogleMaps: results[1],
      canOpenWazeMaps: results[2],
    );
  }

  Future<bool> openAppleMaps() => launchUrlString(appleMapsUrl);
  Future<bool> openGoogleMaps() => launchUrlString(googleMapsUrl);
  Future<bool> openWazeMaps() => launchUrlString(wazeUrl);
}
