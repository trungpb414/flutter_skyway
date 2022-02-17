import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color? backgroundColor;
  const NormalButton({
    Key? key,
    this.backgroundColor,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        onPressed: onPressed,
        child: child);
  }
}
