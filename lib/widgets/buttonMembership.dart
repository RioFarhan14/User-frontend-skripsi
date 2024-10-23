import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonMembership extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const ButtonMembership({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScaleFactor = constraints.maxWidth * 0.0025;
                return FloatingActionButton.extended(
                  elevation: 0,
                  onPressed: onPressed,
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Upgrade to ',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.043 * textScaleFactor,
                            color: textColor,
                          ),
                        ),
                        Image.asset(
                          'assets/images/membershipIcon.png',
                          height: screenWidth * 0.09 * textScaleFactor,
                        ),
                        // Icon(
                        //   Icons.star,
                        //   color: textColor,
                        //   size: screenWidth * 0.08,
                        // ),
                        Text(
                          ' Membership',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.043 * textScaleFactor,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
