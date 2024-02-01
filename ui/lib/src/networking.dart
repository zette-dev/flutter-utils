import 'package:dio/dio.dart';
import 'package:ds_utils/ds_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final apiAuthHeaders = StateProvider<Map<String, String>>(
  (ref) => {},
  dependencies: [],
  name: 'ApiAuthHeaders',
);

final dioClientProvider = Provider.family<Dio, String>(
  (ref, baseUrl) => Dio()
    ..options = BaseOptions(
      baseUrl: 'https://$baseUrl',
      contentType: 'application/json',
      responseType: ResponseType.json,
    )
    ..transformer = BackgroundTransformer()
    ..interceptors.add(InterceptorsWrapper(onRequest: ((options, handler) {
      final authHeaders = ref.read(apiAuthHeaders);
      options.headers.addAll(
        {
          ...authHeaders,
          'Request-Id': const Uuid().v4(),
        },
      );
      return handler.next(options);
    }), onError: ((DioException e, handler) async {
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 401:
            DioException(
              requestOptions: e.requestOptions,
              type: DioExceptionType.badResponse,
              error: UnauthorizedRequestError(),
              response: e.response,
              message: e.message,
              stackTrace: e.stackTrace,
            );
            break;
        }
      }

      return handler.reject(e);
    }))),
  dependencies: [
    apiAuthHeaders,
  ],
);
