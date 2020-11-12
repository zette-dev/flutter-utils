import 'dart:io';

extension FileExtensions on File {
  String get fileExtension => path?.split('.')?.last?.toLowerCase();
}
