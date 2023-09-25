import 'dart:convert';

import 'package:http/http.dart';

abstract class Network {
  final Client httpClient;

  Future<NetworkResponse> post(
      {required Uri url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding});

  Future<NetworkResponse> get({required Uri url, Map<String, String>? headers});

  Network({required this.httpClient});
}

abstract class NetworkResponse {}
