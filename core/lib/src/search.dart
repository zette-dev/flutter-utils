mixin SearchObject {
  bool isSearchMatch(List<String>? searchIndex) => true;
}

mixin SearchModel {
  String? get searchTerm;
  bool get hasSearch => searchTerm?.isNotEmpty ?? false;
  List<String>? get searchIndex => searchTerm?.toSearchIndex();

  List<T> searchResults<T extends SearchObject>(List<T> initialData,
      {bool Function(T)? filter}) {
    final _index = searchIndex;
    List<T> _r = initialData;
    if (filter != null) {
      _r = _r.where(filter).toList();
    }
    if (hasSearch) {
      _r = _r.where((obj) => obj.isSearchMatch(_index)).toList();
    }

    return _r;
  }
}

extension SearchIndex on String {
  List<String> toSearchIndex() => this
      .split(' ')
      .map((e) => e.toLowerCase())
      .where((e) => e.isNotEmpty)
      .toList();
}
