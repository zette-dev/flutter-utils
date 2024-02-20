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
  (ref, baseUrl) {
    final client = Dio()
      ..options = BaseOptions(
        baseUrl: 'https://$baseUrl',
        contentType: 'application/json',
        responseType: ResponseType.json,
      )
      ..transformer = BackgroundTransformer()
      ..interceptors.add(InterceptorsWrapper(
        onRequest: ((options, handler) {
          final authHeaders = ref.read(apiAuthHeaders);
          options.headers.addAll(
            {
              ...authHeaders,
              'Request-Id': const Uuid().v4(),
            },
          );
          return handler.next(options);
        }),
      ));

    return client;
  },
  dependencies: [
    apiAuthHeaders,
  ],
);
