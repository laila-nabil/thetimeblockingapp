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
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    printDebug(
      "[url] $url",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "${body ?? ""}",
    );
    return responseHandler(
        httpResponse: () async => await httpClient.post(uri,
            headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<NetworkResponse> get(
      {required String url, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    printDebug(
      "[url] $url",
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
      {required String url, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    printDebug(
      "[url] $url",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    return responseHandler(
        httpResponse: () async => await http.delete(
              uri,
              headers: headers,
            ));
  }

  @override
  Future<NetworkResponse> put(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding})async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    printDebug(
      "[url] $url",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "${body ?? ""}",
    );
    return responseHandler(
        httpResponse: () async => await httpClient.put(uri,
            headers: headers, body: body, encoding: encoding));
  }
/*@override
  Future<NetworkResponse> post(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    http.Response response;
    try {
      response = await httpClient.post(uri,
          headers: headers, body: body, encoding: encoding);
      if (response.statusCode != 200) {
        throw ServerException(message: response.body.toString());
      }
    } catch (exception) {
      printDebug("Exception $exception", printLevel: PrintLevel.error);
      if (exception is ServerException) {
        rethrow;
      } else {
        throw ServerException(message: exception.toString());
      }
    }
    printDebug(
      "[url] $url",
    );
    printDebug(
      "[header] " "${headers ?? ""}",
    );
    printDebug(
      "[body] " "${body ?? ""}",
    );
    printDebug(
      "[response body] ${response.body}",
    );
    printDebug(
      "[statusCode] " "${response.statusCode}",
    );
    return NetworkResponse.fromHttpResponse(response);
  }

  @override
  Future<NetworkResponse> get(
      {required String url, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(url);
    printDebug(
      "[url] start$url",
    );
    http.Response response;
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw ServerException(message: response.body.toString());
      }
    } catch (exception) {
      printDebug("Exception $exception", printLevel: PrintLevel.error);
      if (exception is ServerException) {
        rethrow;
      } else {
        throw ServerException(message: exception.toString());
      }
    }
    printDebug(
      "[url] $url",
    );
    printDebug("[header] " "$headers");
    printDebug(
      "[response body] ${response.body}",
    );
    printDebug("[statusCode] ${response.statusCode}");
    return NetworkResponse.fromHttpResponse(response);
  }*/
}
