import 'package:chief_week_frontend/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(
      title: 'Chief weekly email',
      home: HomePage(),
    ),
  ));
}
