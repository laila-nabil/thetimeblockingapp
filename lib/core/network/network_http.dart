import 'dart:convert';

import 'package:http/http.dart' as http;

import '../print_debug.dart';
import 'network.dart';

class NetworkHttp implements Network {
  @override
  final http.Client httpClient;

  @override
  final Future<NetworkResponse> Function(
      {required Future<http.Response> Function() httpResponse}) responseHandler;

  NetworkHttp({required this.httpClient, required this.responseHandler});

  @override
  Future<NetworkResponse> post(
      {required Uri uri,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Encoding? encoding}) async {
    final bodyAsString = json.encode(body);
    printDebug(
      "[url] start $uri",
    );
    printDebug(
      "[url] $uri",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "$bodyAsString",
    );
    return responseHandler(
        httpResponse: () async => await httpClient.post(uri,
            headers: headers, body: bodyAsString, encoding: encoding));
  }

  @override
  Future<NetworkResponse> get(
      {required Uri uri, Map<String, String>? headers}) async {
    printDebug(
      "[url] start$uri",
    );
    printDebug(
      "[url] $uri",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    return responseHandler(
        httpResponse: () async => await http.get(
              uri,
              headers: headers,
            ));
  }

  @override
  Future<NetworkResponse> delete(
      {required Uri uri,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    printDebug(
      "[url] start$uri",
    );
    printDebug(
      "[url] $uri",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    return responseHandler(
        httpResponse: () async => await http.delete(uri,
            headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<NetworkResponse> put(
      {required Uri uri,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Encoding? encoding}) async {
    final bodyAsString = json.encode(body);
    printDebug(
      "[url] start$uri",
    );
    printDebug(
      "[url] $uri",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "$bodyAsString",
    );
    return responseHandler(
        httpResponse: () async => await httpClient.put(uri,
            headers: headers, body: bodyAsString, encoding: encoding));
  }

  @override
  Future<NetworkResponse> patch({required Uri uri, Map<String, String>? headers, Map<String, dynamic>? body, Encoding? encoding}) {
    final bodyAsString = json.encode(body);
    printDebug(
      "[url] start$uri",
    );
    printDebug(
      "[url] $uri",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "$bodyAsString",
    );
    return responseHandler(
        httpResponse: () async => await httpClient.patch(uri,
            headers: headers, body: bodyAsString, encoding: encoding));
  }
}
