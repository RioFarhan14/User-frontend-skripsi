import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/screens/profile/editProfile.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/widgets/textProfile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/profile.png',
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
          ),
          SizedBox(height: screenHeight * 0.04),
          SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.24,
              child: Consumer<AuthProvider>(builder: (context, auth, child) {
                final userData = auth.userData;
                return Column(
                  children: [
                    TextContainerProfile(
                      title: 'Nama',
                      field: userData?['name'] ?? 'guest',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextContainerProfile(
                      title: 'Username',
                      field: userData?['username'] ?? 'guest',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextContainerProfile(
                      title: 'No Telepon',
                      field: userData?['user_phone'] ?? 'guest',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextContainerProfile(
                      title: 'Status Pengguna',
                      field: userData?['isMember'] == true
                          ? 'Membership'
                          : 'Guest',
                    ),
                  ],
                );
              })),
          CustomButton1(
            buttonHeight: 0.05,
            buttonWidth: 0.7,
            title: 'Edit Profil',
            onPressed: () {
              // Navigasi ke halaman Edit Profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            backgroundColor: primaryColor,
            colorText: Colors.white,
          ),
          SizedBox(height: screenHeight * 0.01),
          CustomButton1(
            buttonHeight: 0.05,
            buttonWidth: 0.7,
            title: 'Logout',
            onPressed: () async {
              try {
                await authProvider.logout();
              } catch (error) {
                // Tampilkan pesan kesalahan jika diperlukan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout gagal: $error')),
                );
              }
            },
            backgroundColor: Colors.red,
            colorText: Colors.white,
          ),
        ],
      ),
    );
  }
}
