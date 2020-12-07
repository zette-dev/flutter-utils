mixin SearchObject {
  bool isSearchMatch(List<String> searchIndex) => true;
}

mixin SearchModel<T extends SearchObject> {
  String get searchTerm;
  bool get hasSearch => searchTerm != null && searchTerm.isNotEmpty;
  List<String> get searchIndex =>
      searchTerm?.split(' ')?.map((e) => e.toLowerCase())?.toList();

  List<T> searchResults(List<T> initialData, {bool Function(T) filter}) {
    final _index = searchIndex;
    List<T> _r = initialData ?? [];
    if (filter != null) {
      _r = _r.where(filter).toList();
    }
    if (hasSearch) {
      _r = _r.where((obj) => obj.isSearchMatch(_index)).toList();
    }

    return _r;
  }
}
