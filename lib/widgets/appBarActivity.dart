import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class AppBarActivity extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarActivity({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: sizeHeight * 0.1,
      backgroundColor: whiteColor,
      title: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: sizeHeight * 0.025,
            color: Colors.black,
            fontWeight: FontWeight.w600),
      ),
      centerTitle: true, // Memusatkan judul
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
