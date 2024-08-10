import 'package:dartz/dartz.dart' as dartz; 
import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

void main(){
  group("extensions tests", () {
    group("ListDateTimeExtensions tests", () {
      group("datesAIncludesB tests", () {
        test("datesAIncludesB test 1", () {
          List<DateTime> datesA = [
            DateTime(2023,11,1),
            DateTime(2023,11,10),
          ];
          List<DateTime> datesB = [
            DateTime(2023,11,5),
            DateTime(2023,11,6),
          ];
          expect(ListDateTimeExtensions.datesAIncludesB(datesA, datesB), true);
        });
        test("datesAIncludesB test 2", () {
          List<DateTime> datesA = [
            DateTime(2023,11,1),
            DateTime(2023,11,10),
          ];
          List<DateTime> datesB = [
            DateTime(2023,11,1),
            DateTime(2023,11,6),
          ];
          expect(ListDateTimeExtensions.datesAIncludesB(datesA, datesB), true);
        });
        test("datesAIncludesB test 3", () {
          List<DateTime> datesA = [
            DateTime(2023,11,5),
            DateTime(2023,11,10),
          ];
          List<DateTime> datesB = [
            DateTime(2023,11,1),
            DateTime(2023,11,6),
          ];
          expect(ListDateTimeExtensions.datesAIncludesB(datesA, datesB), false);
        });
      });
    });
    group("UriExtension tests", () {
      group("uriHttps tests", () {
        test("uriHttps test 1", () {
          const url = "www.website.com";
          Map<String, String> queryParameters = {
            "keyHere1": "valueHere1",
            "keyHere2": "valueHere2"
          };
          expect(
            UriExtension.uriHttps(url: url, queryParameters: queryParameters),
            Uri(
                scheme: "https",
                host: url,
                path: "",
                queryParameters: queryParameters),
          );
        });
        test("uriHttps test 2", () {
          const url = "www.website.com";
          expect(
            UriExtension.uriHttps(
                url: url),
            Uri(
              scheme: "https",
              host: url,
              path: "",),
          );
        });
      });

    });
  });

}