import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:uuid/uuid.dart';

mixin Identifiable<T> {
  T get id;
}

extension StringIdentifiable on Identifiable<String> {
  bool get hasId => id.isNotEmpty;
}

class NetworkConnectionError implements Exception {}

class UnauthorizedRequestError implements Exception {}

class ApiResponseError implements Exception {
  ApiResponseError(
    this.response, {
    this.code,
    this.request,
    this.errorCode,
    this.localizedMessage,
    this.originalException,
  });
  final RequestOptions? request;
  final Object? response;
  final Object? originalException;
  final String? errorCode, localizedMessage;
  final int? code;

  Map<String, dynamic> toJson() => {
        'request': request?.path,
        'response': response,
        'error_code': errorCode,
        'code': code,
        'request_id': request?.headers['x-request-id'],
        'localized_message': localizedMessage,
      };

  ApiResponseError withErrorCode(String? errorCode, {String? localizedMessage}) => ApiResponseError(
        response,
        errorCode: errorCode,
        code: code,
        request: request,
        originalException: originalException,
        localizedMessage: localizedMessage ?? this.localizedMessage,
      );

  @override
  String toString() => 'ApiResponseError ($code): ${toJson()}';
}

enum HTTPRequestMethod { get, post, put, delete, patch }

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
    this.listFormat,
    this.responseType,
  }) : _extras = {'authenticated': authenticated};

  final String path;
  final String? baseUrl;
  final Map<String, dynamic>? headers, query, _extras;
  final dynamic body;
  final ListFormat? listFormat;
  final HTTPRequestMethod method;
  final bool authenticated, autoRefreshToken;
  final String? contentType;
  final ResponseType? responseType;

  Uri? get uri {
    if (baseUrl != null) {
      final _root = Uri.tryParse(baseUrl ?? '');
      return Uri(scheme: _root!.scheme, host: _root.host, path: path, queryParameters: query);
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
    ListFormat? listFormat,
    ResponseType? responseType,
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
      listFormat: listFormat ?? this.listFormat,
      responseType: responseType ?? this.responseType,
    );
  }

  Future<Response<XFile>> download(Dio client, {String? filePath}) async {
    if (responseType == ResponseType.bytes && filePath == null) {
      return execute(client).then((response) => Response<XFile>(
            data: XFile.fromData(
              response.data as Uint8List,
              lastModified: DateTime.now(),
              mimeType: contentType,
            ),
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            extra: response.extra,
          ));
    } else {
      File _file = await File(filePath!).create();
      return await client
          .download(
            path,
            _file.path,
            data: body,
            queryParameters: query,
            options: Options(
              headers: headers,
              method: methodString,
              extra: _extras,
              contentType: contentType,
              listFormat: listFormat,
            ),
          )
          .then((value) => Response<XFile>(
                data: XFile(_file.path),
                requestOptions: value.requestOptions,
                statusCode: value.statusCode,
                statusMessage: value.statusMessage,
                headers: value.headers,
                isRedirect: value.isRedirect,
                redirects: value.redirects,
                extra: value.extra,
              ));
    }
  }

  Future<Response> execute(
    Dio client, {
    int refreshStatusCode = 401,
    Future Function()? refreshAuth,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Options Function(Options options)? requestOptions,
  }) async {
    var options = Options(
      headers: headers,
      method: methodString,
      responseType: responseType ?? ResponseType.json,
      contentType: contentType?.toString(),
      listFormat: listFormat,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: _extras,
    );

    options = requestOptions?.call(options) ?? options;

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

    Future<Response> _handleUnauthenticatedResponse(dynamic error) async {
      throw UnauthorizedRequestError();
    }

    Future<Response> _handleNetworkIssues(dynamic error) async {
      print('Throw network error');
      throw NetworkConnectionError();
    }

    bool _isResponseError(dynamic e) {
      return e is DioException && e.type == DioExceptionType.badResponse;
    }

    bool _isRefreshableResponeError(dynamic e) {
      return e is DioException &&
          _isResponseError(e) &&
          autoRefreshToken &&
          e.response?.statusCode == refreshStatusCode &&
          refreshAuth != null;
    }

    bool _isNonRefreshableResponeError(dynamic e) {
      return e is DioException && _isResponseError(e) && e.response?.statusCode == refreshStatusCode;
    }

    return await response
        .catchError(_handleFailedResponse, test: _isRefreshableResponeError)
        .catchError(_handleUnauthenticatedResponse, test: _isNonRefreshableResponeError)
        .catchError((e) => e.response, test: _isResponseError)
        .catchError(_handleNetworkIssues,
            test: (e) =>
                e is DioException &&
                e.type == DioExceptionType.connectionError &&
                (e.message?.toLowerCase().contains('failed host lookup') ?? false));
  }

  Future<T> run<T>(
    Dio client, {
    List<int> successCodes = const [200],
    required Future<T> Function(dynamic, int) onSuccess,
    ApiResponseError Function(ApiResponseError)? onError,
    Options Function(Options options)? requestOptions,
  }) {
    return execute(client, requestOptions: requestOptions).then((response) async {
      if (successCodes.contains(response.statusCode)) {
        return onSuccess(response.data, response.statusCode!);
      } else {
        var _error = ApiResponseError(
          response.data,
          code: response.statusCode,
          request: response.requestOptions,
        );

        _error = onError?.call(_error) ?? _error;
        throw _error;
      }
    }).catchError((e) {
      ApiResponseError _error;
      if (e is ApiResponseError) {
        _error = e;
      } else if (e is DioException) {
        _error = ApiResponseError(
          e.response?.data,
          code: e.response?.statusCode,
          request: e.requestOptions,
          originalException: e,
        );
      } else {
        _error = ApiResponseError(
          e.toString(),
          originalException: e,
        );
      }

      _error = onError?.call(_error) ?? _error;
      throw _error;
    });
  }
}

abstract class ServiceInterface {}

abstract class WebServiceInterface extends ServiceInterface {
  WebServiceInterface(this._client) {
    _client.transformer = BackgroundTransformer();
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
  final Dio _client;
  Dio get client => _client;

  void onError(DioException error, ErrorInterceptorHandler handler);

  Future<RequestOptions> authorizationInterceptor(RequestOptions options) async => options;
  Future<RequestOptions> onRequestInterceptor(RequestOptions options) async => options;
}

final $apiAuthHeadersProvider = StateProvider<Map<String, String>>(
  (ref) => {},
  dependencies: [],
  name: 'ApiAuthHeaders',
);

final $dioClientOptionsProvider = Provider<BaseOptions>(
  (ref) => BaseOptions(
    contentType: 'application/json',
    responseType: ResponseType.json,
  ),
);

final $dioClientProvider = Provider.family<Dio, (String, String)>(
  (ref, schemeAndBaseUrl) {
    final client = Dio()
      ..options = ref.read($dioClientOptionsProvider).copyWith(
            baseUrl: '${schemeAndBaseUrl.$1}://${schemeAndBaseUrl.$2}',
          )
      ..transformer = BackgroundTransformer()
      ..interceptors.add(InterceptorsWrapper(onRequest: ((options, handler) {
        final authHeaders = ref.read($apiAuthHeadersProvider);
        options.headers.addAll(
          {
            ...authHeaders,
            'x-request-id': const Uuid().v4(),
          },
        );
        return handler.next(options);
      })))
      ..addSentry();

    return client;
  },
  dependencies: [
    $apiAuthHeadersProvider,
    $dioClientOptionsProvider,
  ],
);
