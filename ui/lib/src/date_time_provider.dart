import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateTimeProvider = Provider.autoDispose<DateTime>((_) => DateTime.now());
