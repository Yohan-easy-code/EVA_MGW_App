import 'package:flutter/material.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';

class BattlePlansErrorState extends StatelessWidget {
  const BattlePlansErrorState({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppSectionCard(
      child: Text(error.toString(), style: TextStyle(color: colorScheme.error)),
    );
  }
}
