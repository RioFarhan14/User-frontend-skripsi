import 'dart:async'; // Import untuk Timer
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/screens/activity/main.dart';
import 'package:user_frontend/screens/home.dart';
import 'package:user_frontend/screens/profile/main.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/widgets/appBarActivity.dart';
import 'package:user_frontend/widgets/appBarHome.dart';
import 'package:user_frontend/widgets/appBarProfile.dart';
import 'package:user_frontend/widgets/buttonMembership.dart';

class MenuNavigation extends StatefulWidget {
  final int initialIndex;

  const MenuNavigation({super.key, this.initialIndex = 0});

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _startFetchingData(); // Mulai fetch data saat widget diinisialisasi
  }

  void _startFetchingData() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.tryAutoLogin();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Consumer<AuthProvider>(builder: (context, auth, child) {
      final userData = auth.userData;
      final isMember = userData?['isMember'] ?? false;

      List<Widget> bodyWidget = [
        const HomePage(),
        const ActivityPage(),
        const ProfilePage(),
      ];

      List<Widget> appWidget = [
        Consumer<AuthProvider>(builder: (context, auth, child) {
          final userData = auth.userData;
          if (userData == null || userData['name'] == null) {
            return const Center(
                child: CircularProgressIndicator()); // Menampilkan loading
          }

          return AppBarHome(
            title: 'Selamat Datang,',
            subtitle: userData['name'],
            onNotificationPressed: () {
              Navigator.pushNamed(context, '/information');
            },
          );
        }),
        const AppBarActivity(
          title: 'Aktivitas',
        ),
        const AppBarProfile(title: 'Profil'),
      ];

      return Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SafeArea(
            child: Container(
          height: sizeHeight * 0.08,
          padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.02),
          margin: EdgeInsets.symmetric(
              horizontal: sizeWidth * 0.05, vertical: sizeHeight * 0.02),
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 20),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(Icons.home_outlined,
                    color: currentIndex == 0
                        ? whiteColor
                        : whiteColor.withOpacity(0.5)),
                label: Text(
                  'Beranda',
                  style: GoogleFonts.poppins(
                    color: currentIndex == 0
                        ? whiteColor
                        : whiteColor.withOpacity(0.5),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  backgroundColor:
                      Colors.transparent, // Warna latar belakang transparan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(Icons.calendar_month_outlined,
                    color: currentIndex == 1
                        ? whiteColor
                        : whiteColor.withOpacity(0.5)),
                label: Text(
                  'Aktivitas',
                  style: GoogleFonts.poppins(
                    color: currentIndex == 1
                        ? whiteColor
                        : whiteColor.withOpacity(0.5),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  backgroundColor:
                      Colors.transparent, // Warna latar belakang transparan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Icon(Icons.person_4_outlined,
                    color: currentIndex == 2
                        ? whiteColor
                        : whiteColor.withOpacity(0.5)),
                label: Text(
                  'Profil',
                  style: GoogleFonts.poppins(
                    color: currentIndex == 2
                        ? whiteColor
                        : whiteColor.withOpacity(0.5),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  backgroundColor:
                      Colors.transparent, // Warna latar belakang transparan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            ],
          ),
        )),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(sizeHeight * 0.12),
          child: appWidget[currentIndex],
        ),
        body: bodyWidget[currentIndex],
        floatingActionButton: currentIndex == 0
            ? Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  final isMember = auth.userData?['isMember'] ?? false;
                  return isMember
                      ? const SizedBox.shrink()
                      : ButtonMembership(
                          backgroundColor: orangeColor,
                          textColor: royalBlue,
                          onPressed: () {
                            Navigator.pushNamed(context, '/membership');
                          },
                        );
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
