import 'package:flutter/material.dart';

class AppColors {
  /*static MaterialColor template = MaterialColor(const Color(0xff).value, const {
    50: Color(0xff),
    100: Color(0xff),
    200: Color(0xff),
    300: Color(0xff),
    400: Color(0xff),
    500: Color(0xff),
    600: Color(0xff),
    700: Color(0xff),
    800: Color(0xff),
    900: Color(0xff),
  });*/

  static Color background = grey.shade50;

  static MaterialColor primary = MaterialColor(const Color(0xff8133F1).value, const {
    50: Color(0xffEFE6FD),
    100: Color(0xffCEB0FA),
    200: Color(0xffB78AF7),
    300: Color(0xff9654F4),
    400: Color(0xff8133F1),
    500: Color(0xff6200EE),
    600: Color(0xff5900D9),
    700: Color(0xff4600A9),
    800: Color(0xff360083),
    900: Color(0xff290064),
  });

  static MaterialColor secondary = MaterialColor(const Color(0xff1671d9).value, const {
    50: Color(0xffe3effc),
    100: Color(0xffb6d8ff),
    200: Color(0xff80bbff),
    300: Color(0xff3d89df),
    400: Color(0xff1671d9),
    500: Color(0xff0d5eba),
    600: Color(0xff034592),
    700: Color(0xff04326b),
    800: Color(0xff012657),
    900: Color(0xff001633),
  });

  ///SEMANTICS

  static MaterialColor warning = MaterialColor(const Color(0xffF3A218).value, const {
    50: Color(0xffFEF6E7),
    100: Color(0xffF7D394),
    200: Color(0xffF7C164),
    300: Color(0xffF5B546),
    400: Color(0xffF3A218),
    500: Color(0xffDD900D),
    600: Color(0xffAD6F07),
    700: Color(0xff865503),
    800: Color(0xff664101),
    900: Color(0xff523300),
  });

  static MaterialColor error = MaterialColor(const Color(0xffD42620).value, const {
    50: Color(0xffFBEAE9),
    100: Color(0xffEB9B98),
    200: Color(0xffE26E6A),
    300: Color(0xffDD524D),
    400: Color(0xffD42620),
    500: Color(0xffCB1A14),
    600: Color(0xffBA110B),
    700: Color(0xff9E0A05),
    800: Color(0xff800501),
    900: Color(0xff591000),
  });

  static MaterialColor success = MaterialColor(const Color(0xff0F973D).value, const {
    50: Color(0xffE7F6EC),
    100: Color(0xff91D6A8),
    200: Color(0xff5FC381),
    300: Color(0xff40B869),
    400: Color(0xff0F973D),
    500: Color(0xff099137),
    600: Color(0xff04802E),
    700: Color(0xff036B26),
    800: Color(0xff015B20),
    900: Color(0xff004617),
  });

 ///NEUTRALS

  static MaterialColor brown = MaterialColor(const Color(0xffA29999).value, const {
    50: Color(0xffFBF1F1),
    100: Color(0xffE4DBDB),
    200: Color(0xffCDC4C4),
    300: Color(0xffB7AFAF),
    400: Color(0xffA29999),
    500: Color(0xff8D8484),
    600: Color(0xff787070),
    700: Color(0xff645D5D),
    800: Color(0xff514A4A),
    900: Color(0xff3E3838),
  });

  static MaterialColor grey = MaterialColor(const Color(0xff98A2B3).value, const {
    50: Color(0xffF9FAFB),
    100: Color(0xffF0F2F5),
    200: Color(0xffE4E7EC),
    300: Color(0xffD0D5DD),
    400: Color(0xff98A2B3),
    500: Color(0xff667185),
    600: Color(0xff475367),
    700: Color(0xff344054),
    800: Color(0xff1D2739),
    900: Color(0xff101928),
  });

  static Color white = Colors.white;

  static Color black = Colors.black;


  static MaterialColor paletteYellow = MaterialColor(const Color(0xfffad469).value, const {
    50: Color(0xfffefaec),
    100: Color(0xfffdeec5),
    200: Color(0xfffce6a9),
    300: Color(0xfffbdb81),
    400: Color(0xfffad469),
    500: Color(0xfff9c943),
    600: Color(0xffe3b73d),
    700: Color(0xffb18f30),
    800: Color(0xff896f25),
    900: Color(0xff69541c),
  });

  static MaterialColor paletteGreen = MaterialColor(const Color(0xff33baa7).value, const {
    50: Color(0xffe6f6f4),
    100: Color(0xffb0e4dd),
    200: Color(0xff8ad7cc),
    300: Color(0xff54c5b5),
    400: Color(0xff33baa7),
    500: Color(0xff00a991),
    600: Color(0xff009a84),
    700: Color(0xff007867),
    800: Color(0xff005d50),
    900: Color(0xff00473d),
  });

  static MaterialColor palettePurple = MaterialColor(const Color(0xff8133F1).value, const {
    50: Color(0xffEFE6FD),
    100: Color(0xffCEB0FA),
    200: Color(0xffB78AF7),
    300: Color(0xff9654F4),
    400: Color(0xff8133F1),
    500: Color(0xff6200EE),
    600: Color(0xff5900D9),
    700: Color(0xff4600A9),
    800: Color(0xff360083),
    900: Color(0xff290064),
  });

  static MaterialColor paletteBlue = MaterialColor(const Color(0xff1671d9).value, const {
  50: Color(0xffe3effc),
  100: Color(0xffb6d8ff),
  200: Color(0xff80bbff),
  300: Color(0xff3d89df),
  400: Color(0xff1671d9),
  500: Color(0xff0d5eba),
  600: Color(0xff034592),
  700: Color(0xff04326b),
  800: Color(0xff012657),
  900: Color(0xff001633),
  });

  static MaterialColor palettePink = MaterialColor(const Color(0xffde7e98).value, const {
    50: Color(0xfffbeff2),
    100: Color(0xfff2cdd7),
    200: Color(0xffecb5c4),
    300: Color(0xffe493a9),
    400: Color(0xffde7e98),
    500: Color(0xffd65e7e),
    600: Color(0xffc35673),
    700: Color(0xff984359),
    800: Color(0xff763445),
    900: Color(0xff5a2735),
  });

  static var text = const Color(0xff080619);
}