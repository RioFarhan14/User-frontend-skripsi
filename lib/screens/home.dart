import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/widgets/buttonMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  15.0), // Sesuaikan radius sesuai kebutuhan
              child: Image.asset(
                'assets/images/homeImg.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: screenHeight * 0.40,
            width: screenWidth * 0.90,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonMenu(
                      BackgroundImage: 'assets/images/pesan.png',
                      icon: Icon(
                        Icons.sports_soccer_sharp,
                        size: screenWidth * 0.08,
                        color: whiteColor,
                      ),
                      text: 'Pesan Lapangan',
                      onPressed: () {
                        Navigator.pushNamed(context, '/booking');
                      },
                    ),
                    ButtonMenu(
                      BackgroundImage: 'assets/images/lihat_jadwal.png',
                      icon: Icon(
                        Icons.event_available_outlined,
                        size: screenWidth * 0.08,
                        color: whiteColor,
                      ),
                      text: 'Lihat Jadwal',
                      onPressed: () {
                        Navigator.pushNamed(context, '/viewSchedule');
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                ButtonMenu(
                  BackgroundImage: 'assets/images/tentang_kami.png',
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: screenWidth * 0.08,
                    color: whiteColor,
                  ),
                  text: 'Tentang Kami',
                  onPressed: () {
                    Navigator.pushNamed(context, '/aboutMe');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
