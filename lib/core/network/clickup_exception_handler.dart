import 'package:equatable/equatable.dart';

import '../error/exceptions.dart';
import '../print_debug.dart';
import 'package:http/http.dart' as http;

import 'network.dart';

Future<NetworkResponse> clickUpResponseHandler(
    {required Future<http.Response> Function() httpResponse}) async {
  http.Response response;
  try {
    response = await httpResponse();
    if (response.statusCode != 200) {
      throw ServerException(
          message: ClickUpError.fromJson(response.body).error);
    }
  } catch (exception) {
    printDebug("[Exception] $exception", printLevel: PrintLevel.error);
    if (exception is ServerException) {
      rethrow;
    } else {
      throw ServerException(message: exception.toString());
    }
  }
  printDebug(
    "[response body] ${response.body}",
  );
  printDebug(
    "[statusCode] " "${response.statusCode}",
  );
  return NetworkResponse.fromHttpResponse(response);
}

class ClickUpError extends Equatable{
  final String error;
  final String errorCode;

  const ClickUpError({required this.error, required this.errorCode});

  factory ClickUpError.fromJson(dynamic json) {
    return ClickUpError(error: json["err"],errorCode: json["ECODE"]);
  }
  @override
  List<Object?> get props => [error,errorCode];

}