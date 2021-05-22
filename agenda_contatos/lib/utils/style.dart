import 'package:flutter/material.dart';

final baseTextStyle = const TextStyle(
  fontFamily: 'Poppins',
);

final headerTextStyle = baseTextStyle.copyWith(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

final defaultColorTextStyle = baseTextStyle.copyWith(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

final imageLetterStyle = baseTextStyle.copyWith(
  color: Colors.white,
  fontSize: 45.0,
  fontWeight: FontWeight.w600,
);

final regularTextStyle = baseTextStyle.copyWith(
  color: Colors.grey[600],
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

final subHeaderTextStyle = regularTextStyle.copyWith(
  fontSize: 14.0,
);
