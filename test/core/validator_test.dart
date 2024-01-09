import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/validator.dart';

void main() {
  group('validator tests', () {
    group('isEmailValid tests', () {
      test('isEmailValid for "laila@gmail.com" should return true', () {
        expect(Validator.isEmailValid("laila@gmail.com"), true);
      });
      test('isEmailValid for "@gmail.com" should return false" ', () {
        expect(Validator.isEmailValid("@gmail.com"), false);
      });
      test('isEmailValid for "_@gmail.com" should return false" ', () {
        expect(Validator.isEmailValid("_@gmail.com"), false);
      });
      test('isEmailValid for "1@gmail.com" should return false" ', () {
        expect(Validator.isEmailValid("1@gmail.com"), false);
      });
      test('isEmailValid for "gmail.com" should return false" ', () {
        expect(Validator.isEmailValid("gmail.com"), false);
      });
      test('isEmailValid for "" should return false" ', () {
        expect(Validator.isEmailValid(""), false);
      });
      test('isEmailValid for " " should return false" ', () {
        expect(Validator.isEmailValid(" "), false);
      });
      test('isEmailValid for "@.com" should return false" ', () {
        expect(Validator.isEmailValid("@.com"), false);
      });
      test('isEmailValid for "laila@asu.edu" should return true" ', () {
        expect(Validator.isEmailValid("laila@asu.edu"), true);
      });
    });
  });
}