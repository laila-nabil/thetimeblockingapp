// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thetimeblockingapp/common/models/clickup_user_model.dart';
import 'package:thetimeblockingapp/core/network/network.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:thetimeblockingapp/features/auth/data/models/access_token_model.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/access_token.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/get_access_token_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/get_user_use_case.dart';

class MockNetwork extends Mock implements Network {}

void main() {
  late MockNetwork mockNetwork;
  late AuthRemoteDataSource dataSource;
  String clickupClientId = "abc-d";
  String clickupClientSecret = "efg-h";
  String clickupUrl = "www.clickup-api.com";

  group('auth remote data source tests', () {
    setUpAll(() {
      registerFallbackValue(Uri());
    });
    setUp(() {
      mockNetwork = MockNetwork();
      dataSource = ClickupAuthRemoteDataSourceImpl(
          network: mockNetwork,
          clickupClientId: clickupClientId,
          clickupClientSecret: clickupClientSecret,
          clickupUrl: clickupUrl);
    });
    group('getClickupAccessToken tests', () {
      test('getClickupAccessToken test', () async {
        const jsonString =
            """{"access_token":"55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152","token_type":"Bearer"} """;
        const model = AccessTokenModel(
            accessToken:
                "55230798_5be9b2e9cd55c9b7e4352ba0c2a743bf6a3fbe047313ae451a8cd6276c7ea152",
            tokenType: "Bearer");
        const code = "123";
        when(() => mockNetwork.post(
                uri: any(named: "uri"),
                body: any(named: "body"),
                encoding: any(named: "encoding"),
                headers: any(named: "headers")))
            .thenAnswer((_) => Future.value(
                const NetworkResponse(body: jsonString, statusCode: 200)));
        final result = await dataSource.getAccessToken(
            params: const GetAccessTokenParams(code));
        print("result $result");
        expect(result, model, reason: ">>> result");
        final captured = verify(() => mockNetwork.post(
            uri: captureAny(named: "uri"),
            body: captureAny(named: "body"),
            encoding: captureAny(named: "encoding"),
            headers: captureAny(named: "headers"))).captured;
        print("captured $captured");
        expect(
            captured[0],
            Uri.tryParse(
                "https://corsproxy.io/?https://api.clickup.com/api/v2/oauth/token?client_id=$clickupClientId&client_secret=$clickupClientSecret&code=$code"),
            reason: ">>> url");
      });
    });
    group('getClickupUser tests', () {
      test('getClickupUser test', ()async {
        final json = {
          "user" :{
             "id" : 55230798,
             "username" : "Laila Nabil",
             "email" : "laila.nabil.mustafa1@gmail.com",
             "color" : "#7b68ee",
             "profilePicture" : null,
             "initials" : "LN",
             "week_start_day" : 0,
             "global_font_support" : true,
             "timezone" : "Africa/Cairo"
          }
        };
        const model = ClickupUserModel(
          id: 55230798,
            username:"Laila Nabil",
           email : "laila.nabil.mustafa1@gmail.com",
           color : "#7b68ee",
           profilePicture : null,
           initials : "LN",
           weekStartDay : 0,
           timezone : "Africa/Cairo",
        );
        const clickupAccessToken = "obmeroikneikn";
        when(() => mockNetwork.get(
            uri: any(named: "uri"),
            headers: any(named: "headers")))
            .thenAnswer((_) => Future.value(
            NetworkResponse(body: jsonEncode(json), statusCode: 200)));
        final result = await dataSource.getClickupUser(
            params: const GetClickupUserParams(AccessToken(accessToken: clickupAccessToken, tokenType: '')));
        print("result $result");
        expect(result, model, reason: ">>> result");
        final captured = verify(() => mockNetwork.get(
            uri: captureAny(named: "uri"),
            headers: captureAny(named: "headers"))).captured;
        print("captured $captured");
        expect(
            captured[0],
            Uri.tryParse(
                "$clickupUrl/user"),
            reason: ">>> url");
      });
    });
  });
}
