mixin Identifiable<T> {
  T get id;
}

extension StringIdentifiable on Identifiable<String> {
    bool get hasId => id.isNotEmpty;
}