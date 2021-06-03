import 'dart:io';

import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

final scopes = const [CalendarApi.calendarScope];
final credentials = Platform.isAndroid ? ClientId("963030593031-4eisub99iuu4vogh4tf8gb6oqr7jfohp.apps.googleusercontent.com", "") : ClientId("", "");
CalendarApi calendar;

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
