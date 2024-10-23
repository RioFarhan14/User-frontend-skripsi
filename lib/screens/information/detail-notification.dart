import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/notifProvider.dart';
import 'package:user_frontend/utils/customAppBar.dart';

class DetailNotification extends StatelessWidget {
  const DetailNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationId = ModalRoute.of(context)!.settings.arguments as int;

    // Mengambil data notifikasi dengan key yang benar dan menangani kasus jika tidak ditemukan
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notificationData = notificationProvider.notifications.firstWhere(
      (notif) => notif['notification_id'] == notificationId,
      orElse: () => {}, // Mengembalikan map kosong jika tidak ditemukan
    );

    // Jika notificationData kosong, tampilkan pesan error atau placeholder
    if (notificationData.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: const CustomAppBar(title: 'Detail'),
        ),
        body: Center(
          child: Text('Notification not found'),
        ),
      );
    }

    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizeWidth * 0.05, vertical: sizeHeight * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Menggunakan kondisi untuk menampilkan ikon yang sesuai
                if (notificationData['category_id'] == 1)
                  FaIcon(
                    FontAwesomeIcons.circleInfo,
                    color: Colors.blue,
                    size: sizeWidth * 0.1,
                  )
                else
                  FaIcon(
                    FontAwesomeIcons.tags,
                    color: Colors.orange,
                    size: sizeWidth * 0.1,
                  ),
                SizedBox(
                  width: sizeWidth * 0.03,
                ),
                Expanded(
                  child: Text(
                    notificationData['title'] ?? 'No Title',
                    style: GoogleFonts.poppins(fontSize: sizeWidth * 0.05),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeHeight * 0.03,
            ),
            Text(
              "Kategori : ${notificationData['category_id'] == 1 ? "info" : "Promo"}", // Menggunakan nilai dari data jika ada
              style: GoogleFonts.poppins(fontSize: sizeWidth * 0.05),
            ),
            SizedBox(
              height: sizeHeight * 0.01,
            ),
            Text(
              "Pesan :",
              style: GoogleFonts.poppins(fontSize: sizeWidth * 0.05),
            ),
            SizedBox(
              height: sizeHeight * 0.01,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notificationData['message'] ?? 'No message',
                  style: GoogleFonts.poppins(fontSize: sizeWidth * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
