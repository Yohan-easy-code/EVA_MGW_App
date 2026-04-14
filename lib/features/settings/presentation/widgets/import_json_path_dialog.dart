import 'package:flutter/material.dart';

class ImportJsonPathDialog extends StatefulWidget {
  const ImportJsonPathDialog({this.initialPath, super.key});

  final String? initialPath;

  @override
  State<ImportJsonPathDialog> createState() => _ImportJsonPathDialogState();
}

class _ImportJsonPathDialogState extends State<ImportJsonPathDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPath ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importer un JSON local'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Saisis le chemin absolu d\'un fichier JSON exporte ou compatible avec le schema applicatif.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Chemin du fichier',
              hintText: '/storage/emulated/0/.../backup.json',
            ),
            minLines: 2,
            maxLines: 3,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Importer'),
        ),
      ],
    );
  }
}
