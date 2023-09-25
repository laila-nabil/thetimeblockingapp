import 'package:http/http.dart';

abstract class Network {
  final Client httpClient;

  Future<NetworkResponse> post();

  Future<NetworkResponse> get();

  Network({required this.httpClient});
}

abstract class NetworkResponse {}
