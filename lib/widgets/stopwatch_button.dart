import 'package:flutter/material.dart';

class StopwatchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const StopwatchButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return OutlinedButton.icon(
      icon: Icon(icon, color: primaryColor),
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(
          color: primaryColor,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
