import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/models/booking.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/providers/bookingProvider.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';

class ChangeSchedule extends StatefulWidget {
  const ChangeSchedule({Key? key}) : super(key: key);

  @override
  _ChangeScheduleState createState() => _ChangeScheduleState();
}

class _ChangeScheduleState extends State<ChangeSchedule> {
  Field? product; // Tipe opsional
  BookingItem? booking; // Tipe opsional
  late String selectedDate;
  late String selectedTime;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<BookingProvider>(context, listen: false)
            .fetchUserBookings();
        final bookingId = ModalRoute.of(context)!.settings.arguments as String;
        booking = await Provider.of<BookingProvider>(context, listen: false)
            .getUserBookingById(bookingId);

        final fields =
            Provider.of<ProductProvider>(context, listen: false).fields;
        // Periksa jika product ditemukan
        product = fields.firstWhere(
          (field) => field.id == booking!.product_id,
          orElse: () => throw Exception(
              'Field not found'), // Menangani kasus item tidak ditemukan
        );

        setState(() {
          if (booking != null) {
            selectedDate = booking!.schedule;
            selectedTime = booking!.start_time;
            isInitialized = true;
          }
        });
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageUrl = '$BASE_URL/images/${product!.image}';
    if (!isInitialized || product == null || booking == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: const CustomAppBar(title: 'Ubah Jadwal'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: const CustomAppBar(title: 'Ubah Jadwal'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.03),
                width: screenWidth * 0.84,
                height: screenHeight * 0.55,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(screenWidth * 0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                      ),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.08, top: screenHeight * 0.035),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          child: Image.network(
                            imageUrl,
                            width: screenWidth * 0.57,
                            height: screenHeight * 0.16,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(product!.name,
                            style: GoogleFonts.poppins(
                                color: blackColor,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Silahkan pilih ulang jadwal booking',
                          style: GoogleFonts.poppins(
                              color: blackColor,
                              fontSize: screenWidth * 0.025,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          'Tanggal',
                          style: GoogleFonts.poppins(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField1(
                          fieldHeight: 0.05,
                          backgroundColor: Colors.grey.shade300,
                          fieldWidth: 0.4,
                          prefixIcon: Icon(
                            Icons.event_available_outlined,
                            color: Colors.black,
                            size: screenWidth * 0.045,
                          ),
                          fontSize: screenWidth * 0.036,
                          readOnly: true,
                          controller: TextEditingController(text: selectedDate),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          'Waktu',
                          style: GoogleFonts.poppins(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField1(
                          fieldHeight: 0.05,
                          backgroundColor: Colors.grey.shade300,
                          fieldWidth: 0.4,
                          prefixIcon: Icon(
                            Icons.alarm_sharp,
                            color: Colors.black,
                            size: screenWidth * 0.045,
                          ),
                          fontSize: screenWidth * 0.036,
                          readOnly: true,
                          controller: TextEditingController(text: selectedTime),
                          onTap: () {
                            _selectTime(context);
                          },
                        ),
                      ]),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Ambil data yang perlu diperbarui, ini adalah contoh
                  final updatedData = {
                    'booking_id': booking
                        ?.id, // Asumsikan Anda memiliki `booking` yang sudah diambil sebelumnya
                    'booking_date': selectedDate,
                    'start_time': selectedTime,
                    // Tambahkan data lain yang diperlukan untuk update
                  };

                  // Ambil `BookingProvider` dari context
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);

                  try {
                    // Panggil metode updateBookingUser untuk memperbarui data booking
                    await bookingProvider.updateBookingUser(updatedData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Berhasil memperbarui booking'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Navigasi setelah pembaruan berhasil
                    Navigator.pop(context);
                  } catch (e) {
                    // Tangani error jika pembaruan gagal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal memperbarui booking: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  width: screenWidth * 0.84,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(screenWidth * 0.06)),
                      color: primaryColor),
                  child: Center(
                    child: Text(
                      'Ubah Jadwal',
                      style: GoogleFonts.poppins(
                          color: whiteColor,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    try {
      final currentDate = DateTime.now();
      final newInitialDate = selectedDate.isEmpty ||
              DateFormat('yyyy-MM-dd')
                  .parse(selectedDate)
                  .isBefore(currentDate) ||
              DateFormat('yyyy-MM-dd')
                  .parse(selectedDate)
                  .isAfter(currentDate.add(const Duration(days: 7)))
          ? currentDate
          : DateFormat('yyyy-MM-dd').parse(selectedDate);

      final newDate = await showDatePicker(
        context: context,
        initialDate: newInitialDate,
        firstDate: currentDate,
        lastDate: currentDate.add(const Duration(days: 7)),
      );

      if (newDate != null) {
        setState(() {
          selectedDate = DateFormat('yyyy-MM-dd')
              .format(newDate); // Update tanggal dengan format string
        });
      }
    } catch (error) {
      print("Error selecting date: $error");
    }
  }

  void _selectTime(BuildContext context) async {
    final newTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(selectedTime)),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });

    if (newTime != null) {
      setState(() {
        selectedTime =
            '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}'; // Format waktu ke string
      });
    }
  }
}
