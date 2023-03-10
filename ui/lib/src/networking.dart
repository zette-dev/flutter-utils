import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'helpers.dart' show compute;

class NetworkConnectionError implements Exception {}

class UnauthorizedRequestError implements Exception {}

class ApiResponseError implements Exception {
  ApiResponseError(this.response,
      {this.code, this.request, this.errorCode, this.localizedMessage});
  final RequestOptions? request;
  final dynamic response;
  final String? errorCode, localizedMessage;
  final int? code;

  String toJson() => json.encode({
        'request': request?.path,
        'response': response,
        'error_code': errorCode,
        'code': code,
        'request_id': request?.headers['Request-Id'],
        'localized_message': localizedMessage,
      });

  ApiResponseError withErrorCode(String? errorCode,
          {String? localizedMessage}) =>
      ApiResponseError(
        response,
        errorCode: errorCode,
        code: code,
        request: request,
        localizedMessage: localizedMessage ?? this.localizedMessage,
      );
}

enum HTTPRequestMethod { get, post, put, delete, patch }

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

  Uri? get uri {
    if (baseUrl != null) {
      final _root = Uri.tryParse(baseUrl ?? '');
      return Uri(
          scheme: _root!.scheme,
          host: _root.host,
          path: path,
          queryParameters: query);
    }

    return null;
  }

  String get methodString {
    switch (method) {
      case HTTPRequestMethod.delete:
        return 'DELETE';
      case HTTPRequestMethod.post:
        return 'POST';
      case HTTPRequestMethod.put:
        return 'PUT';
      case HTTPRequestMethod.patch:
        return 'PATCH';
      case HTTPRequestMethod.get:
      default:
        return 'GET';
    }
  }

  HTTPRequest copyWith({
    String? path,
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? query,
    dynamic body,
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

  Future<T> run<T>(
    Dio client, {
    int successCode = 200,
    required Future<T> Function(dynamic) onSuccess,
    ApiResponseError Function(ApiResponseError)? onError,
  }) {
    return execute(client).then((response) async {
      if (response.statusCode == successCode) {
        return onSuccess(response.data);
      } else {
        var _error = ApiResponseError(
          response.data,
          code: response.statusCode,
          request: response.requestOptions,
        );

        _error = onError?.call(_error) ?? _error;
        throw _error;
      }
    });
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
      onRequest: (options, handler) async {
        options = await onRequestInterceptor(options);
        bool? _authenticated = options.extra['authenticated'];
        if (_authenticated ?? false) {
          options = await authorizationInterceptor(options);
        }

        handler.next(options);
      },
      onError: onError,
    ));
  }
  late Dio _client;
  Dio get client => _client;

  void onError(DioError error, ErrorInterceptorHandler handler);

  Future<RequestOptions> authorizationInterceptor(
          RequestOptions options) async =>
      options;
  Future<RequestOptions> onRequestInterceptor(RequestOptions options) async =>
      options;
}
