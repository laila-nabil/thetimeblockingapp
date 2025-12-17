import 'package:flutter/material.dart';

abstract class AppColors {
  static Color background(bool isDarkMode) =>
      isDarkMode ? Color(0xff101928) : grey(50);

  static MaterialColor _primary(bool isDarkMode) => isDarkMode
      ? MaterialColor(const Color(0xff5e0ecd).value, const {
          50: Color(0xffefe7fa),
          100: Color(0xffcdb4f0),
          200: Color(0xffb590e8),
          300: Color(0xff935ede),
          400: Color(0xff7e3ed7),
          500: Color(0xff5e0ecd),
          600: Color(0xff560dbb),
          700: Color(0xff430a92),
          800: Color(0xff340871),
          900: Color(0xff270656),
        })
      : MaterialColor(const Color(0xff8133F1).value, const {
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

  static Color primary(bool isDarkMode, [int? shade]) => shade != null
      ? (_primary(isDarkMode)[shade] ?? _primary(isDarkMode))
      : _primary(isDarkMode);

  ///SEMANTICS

  static MaterialColor _warning(bool isDarkMode) => isDarkMode
      ? MaterialColor(const Color(0xffe9980c).value, const {
          50: Color(0xffFfdf5e7),
          100: Color(0xfff8dfb4),
          200: Color(0xfff5d08f),
          300: Color(0xfff0ba5c),
          400: Color(0xffedad3d),
          500: Color(0xffe9980c),
          600: Color(0xffd48a0b),
          700: Color(0xffa56c09),
          800: Color(0xff805407),
          900: Color(0xff624005),
        })
      : MaterialColor(const Color(0xffF3A218).value, const {
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

  static Color warning(bool isDarkMode, [int? shade]) => shade != null
      ? (_warning(isDarkMode)[shade] ?? _warning(isDarkMode))
      : _warning(isDarkMode);

  static MaterialColor _error = MaterialColor(const Color(0xffD42620).value, const {
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

  static Color error( [int? shade]) => shade != null
      ? (_error[shade] ?? _error)
      : _error;

  static MaterialColor _success(bool isDarkMode) => isDarkMode
      ? MaterialColor(const Color(0xff0F973D).value, const {
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
        })
      : MaterialColor(const Color(0xff0F973D).value, const {
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

  static Color success(bool isDarkMode, [int? shade]) => shade != null
      ? (_success(isDarkMode)[shade] ?? _success(isDarkMode))
      : _success(isDarkMode);

  ///NEUTRALS

  static MaterialColor _brown(bool isDarkMode) => isDarkMode
      ? MaterialColor(const Color(0xffA29999).value, const {
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
        })
      : MaterialColor(const Color(0xffA29999).value, const {
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

  static Color brown(bool isDarkMode, [int? shade]) => shade != null
      ? (_brown(isDarkMode)[shade] ?? _brown(isDarkMode))
      : _brown(isDarkMode);

  static MaterialColor _grey = MaterialColor(const Color(0xff98A2B3).value, const {
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

  static Color grey([int? shade]) => shade != null
      ? (_grey[shade] ?? _grey)
      : _grey;

  static Color white = Colors.white;

  static Color black = Colors.black;

  static MaterialColor paletteYellow =
      MaterialColor(const Color(0xfffad469).value, const {
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

  static MaterialColor paletteGreen =
      MaterialColor(const Color(0xff33baa7).value, const {
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

  static MaterialColor palettePurple =
      MaterialColor(const Color(0xff8133F1).value, const {
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

  static MaterialColor paletteBlue =
      MaterialColor(const Color(0xff1671d9).value, const {
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

  static MaterialColor palettePink =
      MaterialColor(const Color(0xffde7e98).value, const {
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

  static Color text(bool isDarkMode) =>
      isDarkMode ? const Color(0xffe8e6f9) : const Color(0xff080619);
}
