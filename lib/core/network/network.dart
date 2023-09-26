import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thetimeblockingapp/core/print_debug.dart';

abstract class Network {
  final http.Client httpClient;
  final Future<NetworkResponse> Function(
          {required Future<http.Response> Function() httpResponse})
      responseHandler;

  Future<NetworkResponse> post(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding});

  Future<NetworkResponse> get(
      {required String url, Map<String, String>? headers});

  Network({required this.httpClient,required this.responseHandler});
}

class NetworkResponse {
  final String body;
  final int statusCode;

  NetworkResponse({required this.body, required this.statusCode});

  static NetworkResponse fromHttpResponse(http.Response response) {
    return NetworkResponse(
        body: response.body, statusCode: response.statusCode);
  }
}
