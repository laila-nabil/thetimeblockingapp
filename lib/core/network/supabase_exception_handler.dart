import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../error/exceptions.dart';
import '../print_debug.dart';
import 'package:http/http.dart' as http;

import 'network.dart';

Future<NetworkResponse> supabaseResponseHandler(
    {required Future<http.Response> Function() httpResponse}) async {
  http.Response? response;
  try {
    response = await httpResponse();
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      throw ServerException(
          message: SupabaseError.fromJson(json.decode(response.body))
              .error
              .toString());
    }
    printDebug(
      "[response body] ${response.body}",
    );
    printDebug(
      "[statusCode] " "${response.statusCode}",
    );
  } catch (exception) {
    printDebug(
      "[response body] ${response?.body}",
        printLevel: PrintLevel.error
    );
    printDebug(
      "[statusCode] " "${response?.statusCode}",
      printLevel: PrintLevel.error,
    );
    printDebug("[Exception] 0 ${exception.toString()}",
        printLevel: PrintLevel.error);
    if (response?.statusCode!=204) {
      if (exception is ServerException) {
            printDebug("[Exception] 1 ${exception.message.toString()}",
                printLevel: PrintLevel.error);
            rethrow;
          } else {
            printDebug("[Exception] 2 ${exception.toString()}",
                printLevel: PrintLevel.error);
            throw ServerException(message: exception.toString());
          }
    }
  }

  return NetworkResponse.fromHttpResponse(response!);
}

class SupabaseError extends Equatable{
  final String error;

  const SupabaseError({required this.error,});

  factory SupabaseError.fromJson(Map<String,dynamic> json) {
    return SupabaseError(error: (json["error_description"] ?? json["msg"]).toString(),);
  }
  @override
  List<Object?> get props => [error];

}