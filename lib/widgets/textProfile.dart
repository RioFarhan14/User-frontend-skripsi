import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextContainerProfile extends StatelessWidget {
  final String title;
  final String field;

  const TextContainerProfile({
    Key? key,
    required this.title,
    required this.field,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: screenHeight * 0.017),
        ),
        Text(
          field,
          style: GoogleFonts.poppins(fontSize: screenHeight * 0.017),
        ),
      ],
    );
  }
}
