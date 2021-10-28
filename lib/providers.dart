import 'package:flutter_riverpod/flutter_riverpod.dart';

final writingProvider = StateProvider((ref) => false);
final settingsProvider = StateProvider((ref) => {});
final clearanceProvider = StateProvider((ref) => [false, false, false]);