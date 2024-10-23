import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_frontend/utils/customAppBar.dart';

final Uri _url = Uri.parse(
    'https://www.google.com/maps/place/AM+futsal/@-6.2899929,106.6976336,15z/data=!4m10!1m2!2m1!1sfutsal+am!3m6!1s0x2e69fac70454b92b:0xd0ce0cb1e6e4b49c!8m2!3d-6.2899929!4d106.6976336!15sCglmdXRzYWwgYW2SAQxmdXRzYWxfZmllbGTgAQA!16s%2Fg%2F11c5_6zggv!5m1!1e1?hl=id&entry=ttu');

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    final sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Tentang Kami'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeHeight * 0.05,
          ),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: sizeWidth * 0.5,
              height: sizeHeight * 0.25,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeHeight * 0.04,
                ),
                Text(
                  'AM Futsal adalah tempat penyewaan lapangan futsal yang memiliki 3 lapangan sintetis.',
                  style: TextStyle(fontSize: sizeWidth * 0.045),
                ),
                SizedBox(
                  height: sizeHeight * 0.03,
                ),
                Text(
                  'Lokasi',
                  style: TextStyle(
                      fontSize: sizeWidth * 0.06, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Jalan Jombang Astek No.2, Jombang, Kec. Ciputat, Kota Tangerang Selatan, Banten 15414',
                  style: TextStyle(fontSize: sizeWidth * 0.035),
                ),
                SizedBox(
                  height: sizeHeight * 0.02,
                ),
                GestureDetector(
                  onTap: _launchUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sizeWidth * 0.05),
                    child: Image.asset(
                      'assets/images/map.png',
                      height: sizeHeight * 0.25,
                      width: sizeWidth * 0.8,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
