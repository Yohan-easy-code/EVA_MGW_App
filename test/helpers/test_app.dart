import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/app/theme/app_theme.dart';

Widget buildTestApp(
  Widget child, {
  List<dynamic> overrides = const <dynamic>[],
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(body: child),
    ),
  );
}
