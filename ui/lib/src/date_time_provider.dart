import 'package:riverpod/riverpod.dart';

final currentDateTimeProvider = Provider.autoDispose<DateTime>((_) => DateTime.now());
