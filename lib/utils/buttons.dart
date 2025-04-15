import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color/colors.dart';


class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const GradientIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorFirstGrad, colorSecondGrad],
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: 30.0,
      ),
    );
  }
}