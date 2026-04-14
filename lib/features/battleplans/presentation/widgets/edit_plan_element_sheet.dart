import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_palette.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class ElementEditSheet extends StatefulWidget {
  const ElementEditSheet({
    required this.element,
    required this.type,
    super.key,
  });

  final PlanElement element;
  final PlanElementType type;

  @override
  State<ElementEditSheet> createState() => _ElementEditSheetState();
}

class ElementEditResult {
  const ElementEditResult({required this.color, required this.label});

  final int color;
  final String? label;
}

class _ElementEditSheetState extends State<ElementEditSheet> {
  late final TextEditingController _textController;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.element.color;
    _textController = TextEditingController(text: widget.element.label ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool canEditText = widget.type == PlanElementType.text;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Edition ${widget.type.label.toLowerCase()}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              canEditText
                  ? 'Modifie le texte affiche et la couleur de l\'element.'
                  : 'Choisis une nouvelle couleur pour l\'element selectionne.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (canEditText) ...<Widget>[
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                textInputAction: TextInputAction.done,
                maxLength: 24,
                decoration: const InputDecoration(
                  labelText: 'Texte',
                  hintText: 'Note tactique',
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Couleur',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: battlePlanEditorColors.map((int colorValue) {
                final Color color = Color(colorValue);
                final bool isSelected = _selectedColor == colorValue;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorValue;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : colorScheme.outlineVariant.withAlpha(110),
                        width: isSelected ? 3 : 1.5,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: color.withAlpha(isSelected ? 120 : 60),
                          blurRadius: isSelected ? 16 : 10,
                          spreadRadius: isSelected ? 2 : 0,
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    ElementEditResult(
                      color: _selectedColor,
                      label: canEditText
                          ? _normalizedLabel(_textController.text)
                          : widget.element.label,
                    ),
                  );
                },
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _normalizedLabel(String value) {
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
