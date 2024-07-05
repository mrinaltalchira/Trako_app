// Define your global variables here
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';

const double radiusTextField = 21.0;
const double radiusContainerTextField = 21.0;
const double heightEditText = 50.0;
const double appBarIconHeight = 30.0;

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      backgroundColor: colorMixGrad,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}


class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final IconData? iconData;
  final double? width;
  final double? height;
  final double? radius;
  final bool isNetworkImage;
  final VoidCallback? onTap;

  const CustomImageWidget({
    Key? key,
    this.imageUrl,
    this.iconData,
    this.width,
    this.height,
    this.radius = 0,
    this.isNetworkImage = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (imageUrl != null && isNetworkImage) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && !isNetworkImage) {
      return Image.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (iconData != null) {
      return Icon(
        iconData,
        size: width ?? height ?? 24,
      );
    } else {
      // Placeholder or default widget when imageUrl and iconData are null
      return Container(
        color: Colors.grey[300],
        width: width,
        height: height,
        child: Center(
          child: Text(
            'No Image',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
