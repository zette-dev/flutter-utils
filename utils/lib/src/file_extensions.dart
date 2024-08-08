import 'dart:io';

extension FileExtensions on File {
  String? get fileExtension {
    List<String> _path = path.split('.');
    if (_path.isNotEmpty) {
      return _path.last.toLowerCase();
    }

    return null;
  }
}

extension UriExtensions on Uri {
  String? get fileExtension {
    List<String> _path = path.split('.');
    if (_path.isNotEmpty) {
      return _path.last.toLowerCase();
    }

    return null;
  }
}
