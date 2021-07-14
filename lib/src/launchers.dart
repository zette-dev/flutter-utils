import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dropsource_utils.dart';

Future makeCall(String phoneNumber) async {
  // Strips out extensions
  final _number = phoneNumber.split(', ').first;
  final url = 'tel:$_number';
  if (await canLaunch(url)) {
    return await launch(url);
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
    url += '&$body';
  }
  if (await canLaunch(url)) {
    return await launch(url);
  } else {
    print('Cannot send text: $phoneNumber');
    return null;
  }
}

Future openUrl(String url) async {
  if (await canLaunch(url)) {
    return await launch(url);
  } else {
    print('Cannot open url: $url');
    return null;
  }
}

Future sendEmail(String email, String subject, String body) async {
  final Email _email = Email(
    body: body,
    subject: subject,
    recipients: [email],
  );

  return await FlutterEmailSender.send(_email);
}

class DirectionsLauncher {
  DirectionsLauncher({this.lat, this.lng, this.address}) {
    if (hasCoordinates) {
      canLaunch(appleMapsUrl).then((value) => _canOpenAppleMaps = value);
      canLaunch(googleMapsUrl).then((value) => _canOpenGoogleMaps = value);
      canLaunch(wazeUrl).then((value) => _canOpenWazeMaps = value);
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

  Future<bool> openAppleMaps() => launch(appleMapsUrl, forceSafariVC: false);
  Future<bool> openGoogleMaps() => launch(googleMapsUrl);
  Future<bool> openWazeMaps() => launch(wazeUrl, forceSafariVC: false);
}
