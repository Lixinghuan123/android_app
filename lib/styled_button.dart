import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({super.key,
    required this.onPressed,
    required this.child,
  });
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(style: TextButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 201, 218, 182),
      foregroundColor: Colors.white,
    ),
    onPressed: onPressed,
    child: child,
    );
  }
}