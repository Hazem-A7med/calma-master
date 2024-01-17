import 'package:flutter/material.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.label,
      required this.width,
      required this.fontsize,
      required this.onTap,
      this.backgroundColor,
      this.textColor});

  final String label;
  final double width;
  final double fontsize;
  final void Function() onTap;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 30,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor ?? ColorApp.darkRead,
        ),
        child: Center(
          child: Text(
            label,
            style:
                TextStyle(fontSize: fontsize, color: textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
