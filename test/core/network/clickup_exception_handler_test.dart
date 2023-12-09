// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/error/exceptions.dart';
import 'package:thetimeblockingapp/core/network/clickup_exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:thetimeblockingapp/core/network/network.dart';

void main() {
  group('clickup exception handler tests', () {
    test(
        'clickup exception handler in case of status code 200 returns response as is',
        () async {
      var result = await clickupResponseHandler(
          httpResponse: () async =>
              http.Response(jsonEncode({"dataKey": "data"}), 200));
      print(result);
      expect(
          result,
          NetworkResponse(
              body: jsonEncode({"dataKey": "data"}), statusCode: 200));
    });
    test(
        'clickup exception handler in case of status code 204 returns response as is',
        () async {
      var result = await clickupResponseHandler(
          httpResponse: () async =>
              http.Response(jsonEncode({"dataKey": "data"}), 204));
      print(result);
      expect(
          result,
          NetworkResponse(
              body: jsonEncode({"dataKey": "data"}), statusCode: 204));
    });
    test(
        'clickup exception handler in case of status code 400 returns ServerException',
        () async {
      try {
        await clickupResponseHandler(
            httpResponse: () async => http.Response(
                jsonEncode({"err": "error message", "ECODE": 300}), 400));
      } catch (e) {
        print(e);
        expect(e,isA<ServerException>());
        expect((e as ServerException).message,"error message");
      }
    });
  });

  group('ClickupError tests', () {
    test('ClickupError from json', () {
      final json = {"err": "error message", "ECODE": 400};
      const model = ClickupError(error: "error message", errorCode: "400");
      expect(ClickupError.fromJson(json), model);
    });
  });
}
