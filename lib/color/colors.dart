import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF00BCD4);
const Color secondaryColor = Color(0xFF009688);
const Color accentColor = Color(0xFFFFC107);
const Color white = Color(0xFFFFFFFF);
const Color appBarColor = Color(0xFFFF5722);


const Color colorFirstGrad = Color(0xFFc42c64);
const Color colorFirstGradLite = Color(0xFFF8CFD9);
const Color colorSecondGrad = Color(0xFF6E2775);
const Color colorMixGrad = Color(0xFFb02c6b);
const Color colorText = Color(0xFF000000);
const Color colorHint = Color(0xFFAFAFAF);



// gradients

class LinearGradientDivider extends StatelessWidget {
  final double height;
  final Gradient gradient;

  const LinearGradientDivider({
    super.key,
    required this.height,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}


class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonText; // Updated to be nullable
  final List<Color> gradientColors;
  final double height;
  final double width;
  final double radius;

  GradientButton({
    Key? key,
    required this.onPressed,
    this.buttonText, // Made buttonText optional
    required this.gradientColors,
    required this.height,
    required this.width,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: buttonText != null
              ? Text(
            buttonText!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          )
              : const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}