//only to avoid errors when running tests,may not need it in flutter 3.0
//look at https://github.com/krittapan/kmrs
// ignore_for_file: camel_case_types

class IFrameElement{
  String? width;
  String? height;
  String? src;
  final Style style = Style();
  IFrameElement();
}

class Style{
  String border = "";
}

class window{
  static void open(String a, String b,[String? c]){

  }
}