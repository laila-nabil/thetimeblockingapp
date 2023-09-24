// ignore_for_file: prefer_final_fields

/*
//only to avoid errors when running tests,may not need it in flutter 3.0
//look at https://github.com/krittapan/kmrs
*/

final JsObject context = JsObject(<String, dynamic>{'Object': 'mock'});

class JsObject {
  Map<String, dynamic> _properties = <String, dynamic>{};

  JsObject(this._properties);

  dynamic operator [](String key) => _properties[key];

  void operator []=(String key, dynamic value) {
    _properties[key] = value;
  }

  dynamic callMethod(String method, List<dynamic> args) {
    if (method == 'greet') {
      return "${_properties['greeting']} $args";
    }
    return "";
  }
}