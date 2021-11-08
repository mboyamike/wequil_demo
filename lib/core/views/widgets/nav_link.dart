import 'package:flutter/material.dart';

class NavLink extends StatelessWidget {
  const NavLink({
    Key? key,
    required this.label,
    required this.path,
    this.isActive = false,
    this.onPressed,
  }) : super(key: key);

  final String label;
  final String path;
  final bool isActive;
  final void Function(String path)? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed?.call(path),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.black54,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
