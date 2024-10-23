import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback onNotificationPressed;

  const AppBarHome({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final sizeHeight = constraints.maxHeight;
        final sizeWidth = constraints.maxWidth;

        return AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: sizeHeight * 0.9,
          backgroundColor: whiteColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                    fontSize: sizeHeight * 0.15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
              ),
              SizedBox(
                height: sizeHeight * 0.08,
              ),
              Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: sizeHeight * 0.13,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: sizeWidth * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizeWidth * 0.03),
                  color: primaryColor,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    size: sizeHeight * 0.18,
                    color: whiteColor,
                  ),
                  onPressed: onNotificationPressed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
