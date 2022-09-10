import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search.freezed.dart';

mixin SearchObject {
  bool isSearchMatch(List<String>? searchIndex) => true;
}

mixin SearchModel {
  String? get searchTerm;
  bool get hasSearch => searchTerm?.isNotEmpty ?? false;
  List<String>? get searchIndex => searchTerm?.toSearchIndex();

  List<T> searchResults<T extends SearchObject>(List<T> initialData,
          {bool Function(T)? filter}) =>
      processSearchResults(
        initialData,
        filter: filter,
        searchIndex: searchIndex ?? [],
      );
}

List<T> processSearchResults<T extends SearchObject>(
  List<T> initialData, {
  bool Function(T)? filter,
  List<String> searchIndex = const [],
}) {
  final _index = searchIndex;
  List<T> _r = initialData;
  if (filter != null) {
    _r = _r.where(filter).toList();
  }
  if (searchIndex.isNotEmpty) {
    _r = _r.where((obj) => obj.isSearchMatch(_index)).toList();
  }

  return _r;
}

extension SearchIndex on String {
  List<String> toSearchIndex() => this
      .split(' ')
      .map((e) => e.toLowerCase())
      .where((e) => e.isNotEmpty)
      .toList();
}

typedef SearchFilter<T> = bool Function(T);

@freezed
class SearchParam<T> with _$SearchParam<T> {
  const factory SearchParam({
    required String query,
    SearchFilter<T>? filter,
    @Default([]) List<T> additionalItems,
  }) = _SearchParam;

  // @override
  // List<Object?> get props => [
  //       query,
  //       additionalItems.length,
  //       if (filter != null) filter,
  //     ];
}
