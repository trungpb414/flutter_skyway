import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const ImageButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: const CircleBorder()
        ),
        onPressed: onPressed, child: child);
  }
}