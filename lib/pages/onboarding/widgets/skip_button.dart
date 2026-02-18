import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool visible;

  const SkipButton({
    Key? key,
    required this.onPressed,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Skip',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
