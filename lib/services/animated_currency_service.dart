import 'dart:io';
import 'dart:ui' as ui;
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget currencyNormalFormat(BuildContext context, double moneys,
    {TextStyle? textStyle}) {
  String locale =
      '${ui.window.locale.languageCode}_${ui.window.locale.countryCode}';

  String suffix = '';
  String prefix = '';
  String thousandSeparator = '';
  String decimalSeparator = '';

  var currencyFormat = NumberFormat.simpleCurrency(locale: locale);

  if (locale == 'en_US') {
    suffix = '';
    prefix = currencyFormat.currencySymbol;
    thousandSeparator = ',';
    decimalSeparator = '.';
  } else if (locale == 'ru_RU') {
    suffix = ' ${currencyFormat.currencySymbol}';
    prefix = '';
    thousandSeparator = ' ';
    decimalSeparator = ',';
  } else {
    suffix = '';
    prefix = currencyFormat.currencySymbol;
    thousandSeparator = ',';
    decimalSeparator = '.';
  }

  return AnimatedFlipCounter(
      duration: const Duration(milliseconds: 500),
      fractionDigits: 2,
      thousandSeparator: thousandSeparator,
      decimalSeparator: decimalSeparator,
      suffix: suffix,
      prefix: prefix,
      value: moneys,
      textStyle: textStyle ??
          GoogleFonts.roboto(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ));
}
