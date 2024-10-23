import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/utils/alert.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Daftar',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.1, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Mohon lengkapi informasi berikut untuk mendaftar.',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.032, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Nama',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField1(
                  fontSize: screenHeight * 0.02,
                  fieldHeight: 0.055,
                  fieldWidth: 1,
                  controller: nameController,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Username',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField1(
                  fontSize: screenHeight * 0.02,
                  fieldHeight: 0.055,
                  fieldWidth: 1,
                  controller: usernameController,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Password',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField1(
                  fontSize: screenHeight * 0.02,
                  fieldHeight: 0.055,
                  fieldWidth: 1,
                  controller: passwordController,
                  obscureText: true,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Konfirmasi Password',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField1(
                  fontSize: screenHeight * 0.02,
                  fieldHeight: 0.055,
                  fieldWidth: 1,
                  controller: confirmPasswordController,
                  obscureText: true,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'No Telepon',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035, color: primaryColor),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField1(
                  fontSize: screenHeight * 0.02,
                  fieldHeight: 0.055,
                  fieldWidth: 1,
                  controller: phoneController,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(height: screenHeight * 0.1),
                CustomButton1(
                  title: 'Daftar',
                  onPressed: () async {
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        confirmPasswordController.text.isNotEmpty &&
                        nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      try {
                        await authProvider.register(
                          usernameController.text,
                          passwordController.text,
                          confirmPasswordController.text,
                          nameController.text,
                          phoneController.text,
                        );
                        Navigator.pushNamed(context, '/login');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Registrasi Berhasil!'),
                          backgroundColor: Colors.green,
                        ));
                      } catch (error) {
                        // Handle registration error
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Registrasi gagal: $error'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      showErrorDialog(
                          context, 'Peringatan', 'Semua field harus diisi.');
                    }
                  },
                  backgroundColor: orangeColor,
                  colorText: whiteColor,
                  buttonWidth: 1,
                  buttonHeight: 0.07,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
