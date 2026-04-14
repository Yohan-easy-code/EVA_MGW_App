import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/app_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return buildAppRouter();
});
