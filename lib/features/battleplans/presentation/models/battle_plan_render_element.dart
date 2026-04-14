import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

class BattlePlanRenderElement {
  const BattlePlanRenderElement({required this.element, this.opacity = 1});

  final PlanElement element;
  final double opacity;
}
