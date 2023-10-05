import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

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
  });

}