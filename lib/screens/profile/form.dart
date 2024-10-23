import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/utils/alert.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';

class FormEditProfile extends StatelessWidget {
  const FormEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizewidth = MediaQuery.of(context).size.width;
    final argument = ModalRoute.of(context)!.settings.arguments as String?;
    String title;
    String? digit;
    if (argument == "name") {
      title = "Nama";
      digit = "60";
    } else if (argument == "user_phone") {
      title = "No telepon";
      digit = "13";
    } else if (argument == "username") {
      title = "Username";
      digit = "15";
    } else if (argument == "password") {
      title = "Password";
      digit = "64";
    } else {
      title = '';
      digit = ''; // Default case if argument does not match any known value
    }

    final data = TextEditingController();
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset:
          false, // Menghindari perubahan tata letak saat keyboard muncul
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: CustomAppBar(title: 'Edit $title'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: sizewidth * 0.05, vertical: sizeHeight * 0.05),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: sizewidth * 0.04),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField1(
                        backgroundColor: Colors.grey.shade200,
                        fieldHeight: 0.06,
                        fieldWidth: 0.6,
                        controller: data,
                        fontSize: sizewidth * 0.04,
                      ),
                      Text(
                        "Maksimal $digit Karakter",
                        style: GoogleFonts.poppins(fontSize: sizewidth * 0.03),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: sizeHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton1(
                    buttonHeight: 0.05,
                    buttonWidth: 0.3,
                    onPressed: () async {
                      try {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);

                        if (argument != null && data.text.isNotEmpty) {
                          final updateData = {
                            argument: data.text
                          }; // Pastikan argument tidak null

                          final Response =
                              await authProvider.updateUserData(updateData);

                          Navigator.of(context)
                              .pop(); // Navigate back to the previous page
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Data berhasil diperbarui!'),
                            backgroundColor: Colors.green,
                          ));
                        } else {
                          showErrorDialog(context, 'Peringatan',
                              'Semua field harus diisi.');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Terjadi kesalahan: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    title: 'Simpan',
                    backgroundColor: primaryColor,
                    colorText: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
