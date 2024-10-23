import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height,
      backgroundColor: whiteColor,
      leadingWidth: sizeWidth * 0.17,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: sizeWidth * 0.05),
          child: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.height * 0.02,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
