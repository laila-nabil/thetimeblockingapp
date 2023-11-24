import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Network {
  final http.Client httpClient;
  final Future<NetworkResponse> Function(
          {required Future<http.Response> Function() httpResponse})
      responseHandler;

  Future<NetworkResponse> post(
      {required Uri uri,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Encoding? encoding});

  Future<NetworkResponse> put(
      {required Uri uri,
        Map<String, String>? headers,
        Map<String, dynamic>? body,
        Encoding? encoding});

  Future<NetworkResponse> get(
      {required Uri uri, Map<String, String>? headers});

  Future<NetworkResponse> delete(
      {required Uri uri,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Encoding? encoding});

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
