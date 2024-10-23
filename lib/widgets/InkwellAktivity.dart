import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';

class InkwellActivity extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool left;
  final VoidCallback onTap;

  const InkwellActivity({
    Key? key,
    required this.title,
    required this.left,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: ClipPath(
          clipper: left
              ? LeftSlantedParallelogramClipper()
              : RightSlantedParallelogramClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                      colors: left
                          ? [Color(0xFF101828), Color(0xFF303B4C)]
                          : [Color(0xFF303B4C), Color(0xFF101828)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null, // No gradient when not active
              color: !isActive
                  ? whiteColor
                  : null, // Fallback color when not active
            ),
            width: screenWidth * 0.5,
            height: screenHeight * 0.08,
            alignment: Alignment.center, // Menempatkan teks di tengah-tengah
            child: Text(
              title,
              textAlign: TextAlign
                  .center, // Untuk memastikan teks terpusat secara horizontal
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? whiteColor
                    : Colors.black, // Mengubah warna teks saat aktif
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeftSlantedParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Start from the top-left corner
    path.moveTo(0, 0);
    // Draw a line slanted to the right
    path.lineTo(size.width * 0.9, 0);
    // Draw a line to the bottom-right corner
    path.lineTo(size.width, size.height);
    // Draw a line slanted back to the bottom-left corner
    path.lineTo(0, size.height);
    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightSlantedParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Start from the top-right corner
    path.moveTo(size.width, 0);
    // Draw a line slanted to the left
    path.lineTo(size.width * 0.1, 0);
    // Draw a line to the bottom-left corner
    path.lineTo(0, size.height);
    // Draw a line slanted back to the bottom-right corner
    path.lineTo(size.width, size.height);
    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
