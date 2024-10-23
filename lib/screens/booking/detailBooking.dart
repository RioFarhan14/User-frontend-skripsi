import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/utils/alert.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/utils/timeUtils.dart';

class DetailBookingPage extends StatefulWidget {
  const DetailBookingPage({Key? key}) : super(key: key);

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

String _truncateMessage(String? message) {
  if (message == null) return '';
  return message.length > 80 ? '${message.substring(0, 80)}...' : message;
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  late TextEditingController textDate;
  late TextEditingController textTime;
  late TextEditingController textDuration;
  late int fieldId;
  late Field field;

  @override
  void initState() {
    super.initState();
    textDate = TextEditingController();
    textTime = TextEditingController();
    textDuration = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fieldId = ModalRoute.of(context)!.settings.arguments as int;
    field = Provider.of<ProductProvider>(context, listen: false)
        .fields
        .firstWhere((field) => field.id == fieldId);
  }

  @override
  void dispose() {
    textDate.dispose();
    textTime.dispose();
    textDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageUrl = '$BASE_URL/images/${field.image}';
    final description = _truncateMessage(field.description);
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.07),
          child: const CustomAppBar(title: 'Pesan Lapangan'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.4,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth * 0.04)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 191, 191, 191)
                              .withOpacity(0.2),
                          blurRadius: 3,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(screenHeight * 0.02),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenWidth * 0.05),
                            ),
                            child: Image.network(
                              imageUrl,
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.25,
                              fit: BoxFit
                                  .cover, // Mengubah fit untuk menjaga rasio aspek
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                field.name,
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                description,
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade700),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Pilih Tanggal & Waktu',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  CustomTextField1(
                    backgroundColor: Colors.grey.shade200,
                    controller: textDate,
                    color: Colors.black,
                    fieldHeight: 0.05,
                    fontSize: screenHeight * 0.015,
                    fieldWidth: 0.9,
                    readOnly: true,
                    prefixIcon: Icon(Icons.calendar_today_outlined,
                        color: Colors.grey.shade800),
                    onTap: () {
                      selectDate(context, textDate);
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  CustomTextField1(
                    backgroundColor: Colors.grey.shade200,
                    controller: textTime,
                    color: Colors.black,
                    fieldHeight: 0.05,
                    fontSize: screenHeight * 0.015,
                    fieldWidth: 0.9,
                    readOnly: true,
                    prefixIcon:
                        Icon(Icons.access_alarm, color: Colors.grey.shade800),
                    onTap: () {
                      selectTime(context, textTime);
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Durasi Bermain',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                      CustomTextField1(
                        backgroundColor: Colors.grey.shade200,
                        controller: textDuration,
                        fieldHeight: 0.05,
                        fontSize: screenHeight * 0.015,
                        fieldWidth: 0.3,
                        color: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomButton1(
                    title: 'Checkout',
                    onPressed: () {
                      if (textDate.text.isNotEmpty &&
                          textTime.text.isNotEmpty &&
                          textDuration.text.isNotEmpty) {
                        Navigator.pushNamed(context, '/checkout', arguments: {
                          'product_id': field.id,
                          'start_time': textTime.text,
                          'booking_date': textDate.text,
                          'duration': textDuration.text,
                        });
                      } else {
                        showErrorDialog(
                            context, 'Peringatan', 'Semua field harus diisi.');
                      }
                    },
                    backgroundColor: primaryColor,
                    colorText: Colors.white,
                    buttonWidth: 0.9,
                    buttonHeight: 0.06,
                  ),
                ],
              )),
        ));
  }
}
