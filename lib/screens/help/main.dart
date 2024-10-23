import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/FaqProvider.dart'; // Pastikan ini sesuai dengan lokasi sebenarnya
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/theme.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    // Fetch help data when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FaqProvider>(context, listen: false).fetchFaqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final faqProvider = Provider.of<FaqProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Bantuan'),
      ),
      body: faqProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : faqProvider.faqs.isEmpty
              ? const Center(child: Text('Data Tidak Tersedia'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: sizeHeight * 0.02,
                        horizontal: sizeWidth * 0.075,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pertanyaan Umum Yang',
                            style: GoogleFonts.poppins(
                                fontSize: sizeWidth * 0.05,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Sering Diajukan',
                            style: GoogleFonts.poppins(
                                fontSize: sizeWidth * 0.05,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: sizeWidth * 0.85,
                          child: ListView.builder(
                            itemCount: faqProvider.faqs.length,
                            itemBuilder: (context, index) {
                              final infoHelp = faqProvider.faqs[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: sizeHeight * 0.01),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        sizeWidth * 0.03)),
                                child: ExpansionTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(sizeWidth * 0.03),
                                  ),
                                  title: Text(
                                    infoHelp['title'] ?? 'No title',
                                    style:
                                        GoogleFonts.poppins(color: whiteColor),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sizeHeight * 0.02,
                                          vertical: sizeHeight * 0.02),
                                      child: Text(
                                        infoHelp['message'] ?? 'No detail',
                                        style: GoogleFonts.poppins(
                                            color: whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: sizeWidth,
                      padding: EdgeInsets.all(sizeWidth * 0.04),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadiusDirectional.vertical(
                              top: Radius.circular(sizeWidth * 0.04))),
                      height: sizeHeight * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masih Butuh Bantuan ?',
                            style: GoogleFonts.poppins(
                                color: orangeColor, fontSize: sizeWidth * 0.05),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.01,
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.phoneVolume,
                                size: sizeWidth * 0.08,
                                color: orangeColor,
                              ),
                              SizedBox(
                                width: sizeWidth * 0.05,
                              ),
                              Text(
                                '08975382049',
                                style: GoogleFonts.poppins(
                                    fontSize: sizeWidth * 0.05,
                                    color: orangeColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
