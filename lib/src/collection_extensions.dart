import 'common_enums.dart';
import 'networking.dart';

extension MapListMethods<K, T> on Map<K, List<T>> {
  Map<K, List<T>> filter(
    bool Function(K, T) filterList,
  ) {
    final List<K> _keys = keys?.toList() ?? [];
    if (_keys.isNotEmpty) {
      _keys.sort();
    }
    var map = <K, List<T>>{};
    for (var key in _keys) {
      final _list = this[key].where((v) => filterList(key, v)).toList();
      if (_list.isNotEmpty) {
        map.putIfAbsent(key, () => _list);
      }
    }
    return map;
  }
}

extension MapMethods<K, T> on Map {
  Map<K, T> filterOutNulls() {
    final Map<K, T> filtered = <K, T>{};
    forEach((key, value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  Map<K, T> sortKeys() {
    final _keys = keys.toList() ?? [];
    if (_keys.isNotEmpty) {
      _keys.sort();
    }
    var map = <K, T>{};
    for (var k in _keys) {
      map.putIfAbsent(k, () => this[k]);
    }
    return map;
  }
}

extension ListMethods<T> on List<T> {
  List<T> filterOutNulls() =>
      isNotEmpty ? where((item) => item != null).toList() : <T>[];

  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
      <K, List<T>>{},
      (Map<K, List<T>> map, T element) =>
          map..putIfAbsent(keyFunction(element), () => <T>[]).add(element));
}

extension IterableMethods<T> on Iterable<T> {
  T get tryFirst => isNotEmpty ? first : null;
}

extension ListOfListMethods<T> on List<List<T>> {
  List<T> flatten() => isNotEmpty
      ? reduce((l1, l2) {
          for (var item in l2) {
            if (!l1.contains(item)) {
              l1.add(item);
            }
          }

          return l1;
        })
      : <T>[];
}

extension IdentifiableListMethods<T extends Identifiable> on List<T> {
  List<T> merge({
    MergeDirection direction,
    List<T> newList,
  }) {
    if (direction == null || direction == MergeDirection.replace) {
      return newList;
    } else {
      Map<String, T> _indexedNew = newList.index();

      // Replace any existing items in the initialList
      List<T> _updatedList = map((e) {
        T _obj = _indexedNew[e.id];
        if (_obj == null) {
          return e;
        } else {
          _indexedNew.remove(e.id);
          return _obj;
        }
      }).toList();

      if (direction == MergeDirection.append) {
        _updatedList.addAll(_indexedNew.values);
        return _updatedList;
      } else {
        List<T> _returnableList = _indexedNew.values.toList()
          ..addAll(_updatedList);
        return _returnableList;
      }
    }
  }
}

extension IdentifiableIterableMethods<T extends Identifiable> on Iterable<T> {
  Map<String, T> index({List<T> merge}) {
    return Map<String, T>.fromIterable(
      [...this, ...(merge ?? [])],
      key: (item) => item.id,
      value: (item) => item,
    );
  }
}

// Stream<List<T>> mergeStreamsList<T>(List<Stream<List<T>>> streams,
//         {int Function(T, T) sorter}) =>
//     Rx.combineLatest<List<T>, List<T>>(streams, (list) {
//       final _combined = flattenList(list);
//       if (sorter != null) _combined.sort(sorter);
//       return _combined.toList();
//     });

// Future<List<T>> mergeFuturesList<T>(List<Future<List<T>>> futures,
//         {int Function(T, T) sorter}) =>
//     Future.wait(futures).then((list) {
//       final _combined = flattenList(list);
//       if (sorter != null) _combined.sort(sorter);
//       return _combined.toList();
//     });

extension FutureListExtension<T> on List<Future<List<T>>> {
  Future<List<T>> mergeFuturesList({int Function(T, T) sorter}) =>
      Future.wait(this).then((list) {
        final _combined = list?.flatten()?.toList() ?? [];
        if (sorter != null && _combined.isNotEmpty) {
          _combined.sort(sorter);
        }
        return _combined.toList();
      });
}
