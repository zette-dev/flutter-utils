import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'helpers.dart' show compute;

class NetworkConnectionError implements Exception {}

class UnauthorizedRequestError implements Exception {}

class ApiResponseError implements Exception {
  ApiResponseError(this.message, {this.code, this.request});
  final RequestOptions? request;
  final String message;
  final int? code;

  String toJson() => json.encode({
        'request': request?.path,
        'message': message,
        'code': code,
        'request_id': request?.headers['Request-Id'],
      });
}

enum HTTPRequestMethod { GET, POST, PUT, DELETE, PATCH }

@immutable
class HTTPRequest {
  HTTPRequest({
    required this.method,
    required this.path,
    this.baseUrl,
    this.headers,
    this.query,
    this.body,
    this.contentType,
    this.authenticated = false,
    this.autoRefreshToken = false,
  });

  final String path;
  final String? baseUrl;
  final Map<String, String>? headers, query;
  final dynamic body;
  final HTTPRequestMethod method;
  final bool authenticated, autoRefreshToken;
  final String? contentType;

  String get methodString {
    switch (method) {
      case HTTPRequestMethod.DELETE:
        return 'DELETE';
      case HTTPRequestMethod.POST:
        return 'POST';
      case HTTPRequestMethod.PUT:
        return 'PUT';
      case HTTPRequestMethod.PATCH:
        return 'PATCH';
      case HTTPRequestMethod.GET:
      default:
        return 'GET';
    }
  }

  HTTPRequest copyWith({
    String? path,
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? query,
    dynamic? body,
    HTTPRequestMethod? method,
    String? contentType,
    bool? authenticated,
  }) {
    return HTTPRequest(
      path: path ?? this.path,
      headers: headers ?? this.headers,
      query: query ?? this.query,
      body: body ?? this.body,
      method: method ?? this.method,
      contentType: contentType ?? this.contentType,
      authenticated: authenticated ?? this.authenticated,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }

  Future<Response> download(Dio client, String savePath) async {
    Map<String, dynamic> _extras = {'authenticated': false};
    if (authenticated) {
      _extras['authenticated'] = true;
    }

    File _file = await File(savePath).create();

    return await client.download(
      path,
      _file.path,
      data: body,
      queryParameters: query,
      options: Options(
        headers: headers,
        method: methodString,
        extra: _extras,
        contentType: contentType,
      ),
    );
  }

  Future<Response> execute(
    Dio client, {
    int refreshStatusCode = 401,
    Future Function()? refreshAuth,
  }) async {
    Map<String, dynamic> _extras = {'authenticated': false};
    if (authenticated) {
      _extras['authenticated'] = true;
    }

    var options = Options(
      headers: headers,
      method: methodString,
      extra: _extras,
      responseType: ResponseType.json,
      contentType: contentType?.toString(),
    );

    Future<Response> response = client.request(
      path,
      data: body,
      queryParameters: query,
      options: options,
    );

    Future<Response> _handleFailedResponse(dynamic error) async {
      // auto refresh auth if enabled
      return await (refreshAuth!().then((res) async {
        return await execute(client);
      }));
    }

    void _handleUnauthenticatedResponse(dynamic error) {
      throw UnauthorizedRequestError();
    }

    void _handleNetworkIssues(dynamic error) {
      print('Throw network error');
      throw NetworkConnectionError();
    }

    bool _isResponseError(dynamic e) {
      return e is DioError && e.type == DioErrorType.response;
    }

    bool _isRefreshableResponeError(dynamic e) {
      return e is DioError &&
          _isResponseError(e) &&
          autoRefreshToken &&
          e.response?.statusCode == refreshStatusCode &&
          refreshAuth != null;
    }

    bool _isNonRefreshableResponeError(dynamic e) {
      return e is DioError &&
          _isResponseError(e) &&
          e.response?.statusCode == refreshStatusCode;
    }

    return await response
        .catchError(_handleFailedResponse, test: _isRefreshableResponeError)
        .catchError(_handleUnauthenticatedResponse,
            test: _isNonRefreshableResponeError)
        .catchError((e) => e.response, test: _isResponseError)
        .catchError(_handleNetworkIssues,
            test: (e) =>
                e is DioError &&
                e.type == DioErrorType.other &&
                e.message.toLowerCase().contains('failed host lookup'));
  }
}

class FlutterJsonTransformer extends DefaultTransformer {
  FlutterJsonTransformer() : super(jsonDecodeCallback: _parseJson);
}

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class ServiceInterface {}

abstract class WebServiceInterface extends ServiceInterface {
  WebServiceInterface(this._client) {
    _client.transformer = FlutterJsonTransformer();
    _client.interceptors.add(InterceptorsWrapper(
      onRequest: (options) async {
        options = onRequestInterceptor(options);
        if (options.extra['authenticated'] as bool ?? false) {
          options = authorizationInterceptor(options);
        }

        return options;
      },
    ));
  }
  Dio _client;
  Dio get client => _client;

  dynamic authorizationInterceptor(RequestOptions options) => options;
  dynamic onRequestInterceptor(RequestOptions options) => options;
}

mixin Identifiable<T> {
  T get id;
}
