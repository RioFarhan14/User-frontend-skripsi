import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class ButtonMenu extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String BackgroundImage;
  final Widget icon;

  const ButtonMenu({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.BackgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk mendapatkan ukuran layar
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenHeight * 0.02),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(screenHeight * 0.02)),
            image: DecorationImage(
              image: AssetImage(BackgroundImage),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black
                    .withOpacity(0.5), // Warna overlay dengan transparansi
                BlendMode
                    .darken, // Mode blending untuk membuat gambar lebih gelap
              ),
            )),
        width: screenHeight * 0.2,
        height: screenHeight * 0.12,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sizeHeight = constraints.maxHeight;
            final sizeWidth = constraints.maxWidth;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: sizeWidth * 0.03),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                      color: whiteColor,
                      fontSize: sizeWidth * 0.08,
                      fontWeight: FontWeight.w900),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
