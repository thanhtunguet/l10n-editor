import 'package:flutter/material.dart';

class HomeIcon extends StatelessWidget {
  final String label;

  final void Function()? onPressed;

  final IconData icon;

  const HomeIcon({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon),
            iconSize: 40,
            tooltip: label,
            color: Theme.of(context).primaryColor,
            onPressed: onPressed,
          ),
          Text(label),
        ],
      ),
    );
  }
}
