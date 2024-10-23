import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton1 extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color colorText;
  final double buttonWidth;
  final double buttonHeight;
  final double? fontSize;
  final Widget? icon;
  final FontWeight? fontWeight;

  const CustomButton1({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.colorText,
    this.icon,
    required this.buttonWidth,
    required this.buttonHeight,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(
            screenWidth * buttonWidth,
            screenHeight * buttonHeight,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding
        ),
      ),
      onPressed: onPressed,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sizeHeight = constraints.maxHeight;
          return Row(
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 8.0), // Space between icon and text
              ],
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: colorText,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontSize: fontSize ?? sizeHeight * 0.35,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
