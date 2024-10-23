import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class CustomTextField1 extends StatelessWidget {
  const CustomTextField1({
    Key? key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    required this.fieldHeight,
    required this.fieldWidth,
    this.color,
    this.prefixIcon,
    this.fontSize,
    this.onTap,
    this.backgroundColor,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final double fieldWidth;
  final double fieldHeight;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final double? fontSize;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  final Color? color;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * fieldHeight,
      width: screenWidth * fieldWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenHeight * 0.015),
          bottomRight: Radius.circular(screenHeight * 0.015),
        ),
        color: backgroundColor ?? whiteColor,
      ),
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        enabled: enabled,
        style: GoogleFonts.poppins(
          fontSize: fontSize ?? screenHeight * 0.022,
          color: color ?? blackColor,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: prefixIcon!,
                )
              : null,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenHeight * 0.015),
              bottomRight: Radius.circular(screenHeight * 0.015),
            ),
          ),
        ),
      ),
    );
  }
}
