import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class AppBarProfile extends StatelessWidget {
  final String title;

  const AppBarProfile({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return AppBar(
      backgroundColor: whiteColor,
      automaticallyImplyLeading: false,
      toolbarHeight: sizeHeight,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: sizeHeight * 0.025,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true, // Memusatkan judul
    );
  }
}
