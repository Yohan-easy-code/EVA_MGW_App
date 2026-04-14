import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

class CreateBattlePlanDialog extends StatefulWidget {
  const CreateBattlePlanDialog({required this.mapAssets, super.key});

  final List<MapAsset> mapAssets;

  @override
  State<CreateBattlePlanDialog> createState() => _CreateBattlePlanDialogState();
}

class _CreateBattlePlanDialogState extends State<CreateBattlePlanDialog> {
  late final TextEditingController _controller;
  late int _selectedMapId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedMapId = widget.mapAssets.first.id;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau battleplan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nom du battleplan',
              hintText: 'Alpha Push',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedMapId,
            decoration: const InputDecoration(labelText: 'Carte'),
            items: widget.mapAssets.map((MapAsset map) {
              return DropdownMenuItem<int>(
                value: map.id,
                child: Text(map.displayName),
              );
            }).toList(),
            onChanged: (int? value) {
              if (value == null) {
                return;
              }

              setState(() {
                _selectedMapId = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              CreateBattlePlanInput(
                name: _controller.text.trim(),
                mapId: _selectedMapId,
              ),
            );
          },
          child: const Text('Creer'),
        ),
      ],
    );
  }
}

class CreateBattlePlanInput {
  const CreateBattlePlanInput({required this.name, required this.mapId});

  final String name;
  final int mapId;
}
