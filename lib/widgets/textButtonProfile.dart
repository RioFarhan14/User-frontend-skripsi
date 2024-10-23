import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonProfile extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const TextButtonProfile({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.6,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(screenWidth * 0.03),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Colors.black,
              size: screenWidth * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
