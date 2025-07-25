import 'package:flutter/material.dart';class BioBox extends StatelessWidget {
  final String text;

  const BioBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedText = text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Text(
        trimmedText.isNotEmpty ? trimmedText : "No bio added yet.",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
