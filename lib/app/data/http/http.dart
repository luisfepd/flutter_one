import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../domain/either/either.dart';

part 'failure.dart';
part 'logs.dart';
part 'parse_response_body.dart';

enum HttpMethod { get, post, put, patch, delete }

class Http {
  Http({
    required Client client,
    required String baseUrl,
    required String apiKey,
  })  : _client = client,
        _baseUrl = baseUrl,
        _apiKey = apiKey;

  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Future<Either<HttpFailure, R>> request<R>(String path,
      {required R Function(dynamic responseBody) onSuccess,
      HttpMethod method = HttpMethod.get,
      Map<String, String> headers = const {},
      Map<String, String> queryParameters = const {},
      Map<String, dynamic> body = const {},
      bool useAPIKey = true}) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTrace;
    try {
      if (useAPIKey == true) {
        queryParameters = {
          ...queryParameters,
          'api_key': _apiKey,
        };
      }

      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );

      if (queryParameters.isNotEmpty) {
        url = url.replace(
          queryParameters: queryParameters,
        );
      }
      headers = {
        'Content-Type': 'application/json',
        ...headers,
      };

      late final Response response;
      final bodyString = jsonEncode(body);

      logs = {
        'url': url.toString(),
        'method': method.name,
        'startTime': DateTime.now().toString(),
        'body': body,
      };

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url);
          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
      }

      final statusCode = response.statusCode;

      final responseBody = _parseResponseBody(response.body);
      logs = {
        ...logs,
        'statusCode': statusCode,
        'responseBody': responseBody,
      };

      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(
          onSuccess(responseBody),
        );
      }

      return Either.left(HttpFailure(
        statusCode: statusCode,
        data: responseBody,
      ));
    } on Exception catch (e, s) {
      stackTrace = s;
      logs = {
        ...logs,
        'exception': e.runtimeType.toString(),
      };
      if (e is SocketException || e is ClientException) {
        logs = {
          ...logs,
          'exception': 'NetworkException',
        };
        return Either.left(HttpFailure(
          exception: NetworkException(),
        ));
      }

      return Either.left(HttpFailure(
        exception: e,
      ));
    } finally {
      logs = {
        ...logs,
        'endTime': DateTime.now().toString(),
      };
      // _printLogs(
      //   logs,
      //   stackTrace,
      // );
    }
  }
}
