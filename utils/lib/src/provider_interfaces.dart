import 'package:zette_utils/zette_utils.dart';

mixin ListProviderInterface<T extends SearchObject> {
  List<T> get data;
  List<T> search(SearchParam<T> search) => processSearchResults<T>(
        data,
        searchIndex: search.query.toSearchIndex(),
        filter: search.filter,
      );

  T? get(String? id);

  T getOr(String? id, {required T orElse}) => get(id) ?? orElse;
}
