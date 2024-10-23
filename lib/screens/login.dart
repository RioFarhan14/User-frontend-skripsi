import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/providers/notifProvider.dart';
import 'package:user_frontend/utils/alert.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/utils/flutterNotification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterNotification _flutterNotification = FlutterNotification();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              CustomTextField1(
                fieldHeight: 0.053,
                fieldWidth: 1,
                fontSize: screenHeight * 0.017,
                controller: usernameController,
                prefixIcon: FaIcon(
                  FontAwesomeIcons.user,
                  color: blackColor,
                ),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              CustomTextField1(
                fieldHeight: 0.053,
                fieldWidth: 1,
                fontSize: screenHeight * 0.017,
                controller: passwordController,
                obscureText: true,
                prefixIcon: FaIcon(
                  FontAwesomeIcons.lock,
                  color: blackColor,
                ),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(height: screenHeight * 0.08),
              CustomButton1(
                title: 'Masuk',
                onPressed: () async {
                  if (usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    try {
                      await _flutterNotification.init(context);
                      final String? fcmToken = await _getToken();
                      print('FCM token: $fcmToken');
                      if (fcmToken != null) {
                        handleBackgroundMessage(context);
                        await authProvider.login(usernameController.text,
                            passwordController.text, fcmToken);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      } else {
                        // Handle case when fcmToken is null
                        throw 'FCM token is null';
                      }
                    } catch (error) {
                      // Handle login error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Login gagal: $error'),
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
                buttonHeight: 0.06,
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text.rich(
                TextSpan(
                  text: 'Belum punya akun ? ',
                  style: GoogleFonts.poppins(color: primaryColor, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Daftar Sekarang !',
                      style: GoogleFonts.poppins(
                          color: orangeColor,
                          decoration: TextDecoration.underline,
                          decorationColor: orangeColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/register');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleBackgroundMessage(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notificationId = message.data['notification_id'];
      if (notificationId != null) {
        final notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.isRead(notificationId);

        // Navigate to the detail page with appropriate context checks
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushNamed(
            context,
            '/detailInfo',
            arguments: notificationId,
          );
        }
      } else {
        print('No notification ID found in the message data');
      }
    });
  }

  Future<String?> _getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken!);
    return fcmToken;
  }
}
