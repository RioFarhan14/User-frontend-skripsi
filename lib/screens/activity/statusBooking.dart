import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/providers/bookingProvider.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/services/midtrans-service.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart'; // Pastikan versi dan package sesuai

class StatusBooking extends StatefulWidget {
  const StatusBooking({super.key});

  @override
  _StatusBookingState createState() => _StatusBookingState();
}

class _StatusBookingState extends State<StatusBooking> {
  MidtransSDK? _midtrans;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<BookingProvider>(context, listen: false)
          .fetchUserBookings();
      await Provider.of<ProductProvider>(context, listen: false).fetchData();
      await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
      await _initSDK();
    });
  }

  Future<void> _initSDK() async {
    try {
      _midtrans =
          await MidtransService.initializeSDK(context, MIDTRANS_CLIENT_KEY);
      if (_midtrans == null) {
        print('Failed to initialize MidtransSDK');
      } else {
        print('MidtransSDK initialized successfully');
      }
    } catch (e) {
      print('Error initializing MidtransSDK: $e');
      MidtransService.showToast('SDK Initialization Failed', true);
    }
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isMember = auth.userData?['isMember'] ?? false;
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        if (bookingProvider.isLoading) {
          return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF101828), Color(0xFF475467)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(child: CircularProgressIndicator()));
        }

        final bookings = bookingProvider.userBookings;

        if (bookings.isEmpty) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(screenWidth * 0.05)),
                gradient: const LinearGradient(
                  colors: [Color(0xFF101828), Color(0xFF303B4C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                  child: Text(
                'Pesanan Tidak Tersedia',
                style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )));
        }
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Scaffold(
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF101828), Color(0xFF303B4C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final product = productProvider
                        .getDataById(booking.product_id) as Field;

                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      height: screenHeight * 0.25,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final sizeWidth = constraints.maxWidth;
                          final sizeHeight = constraints.maxHeight;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: sizeHeight * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(screenWidth * 0.04),
                                      topRight:
                                          Radius.circular(screenWidth * 0.04)),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF475467),
                                      Color(0xFF667085)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  height: sizeHeight * 0.2,
                                  padding:
                                      EdgeInsets.only(left: sizeWidth * 0.05),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_available_outlined,
                                        color: primaryColor,
                                        size: sizeWidth * 0.07,
                                      ),
                                      SizedBox(width: sizeWidth * 0.01),
                                      Text(
                                        'Pesanan',
                                        style: GoogleFonts.poppins(
                                          color: whiteColor,
                                          fontSize: sizeHeight * 0.07,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: sizeHeight * 0.1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nama Lapangan',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: sizeHeight * 0.01),
                                      Text(
                                        product.name,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status Pesanan',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: sizeHeight * 0.01),
                                      Text(
                                        booking.statusBook,
                                        style: GoogleFonts.poppins(
                                            color:
                                                booking.statusBook == 'Ongoing'
                                                    ? Colors.green
                                                    : booking.statusBook ==
                                                            'Pending'
                                                        ? Colors.red
                                                        : Colors.blue,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Waktu',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: sizeHeight * 0.01),
                                      Text(
                                        booking.schedule,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: sizeHeight * 0.06,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: sizeHeight * 0.1),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sizeWidth * 0.04),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer_sharp,
                                          color: orangeColor,
                                          size: sizeHeight * 0.1,
                                        ),
                                        SizedBox(width: sizeWidth * 0.01),
                                        Text(
                                          booking.start_time,
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey.shade800,
                                              fontSize: sizeHeight * 0.06,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    if (booking.statusBook == 'Booked' &&
                                        isMember == true) ...[
                                      CustomButton1(
                                        title: 'Ubah Jadwal',
                                        fontWeight: FontWeight.bold,
                                        fontSize: sizeHeight * 0.075,
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/changeSchedule',
                                            arguments: booking.id,
                                          );
                                        },
                                        backgroundColor: primaryColor,
                                        colorText: Colors.white,
                                        buttonWidth: 0.35,
                                        buttonHeight: 0.055,
                                      ),
                                    ],
                                    if (booking.statusBook == 'Pending') ...[
                                      CustomButton1(
                                        title: 'Bayar',
                                        fontWeight: FontWeight.bold,
                                        fontSize: sizeHeight * 0.075,
                                        onPressed: () async {
                                          try {
                                            final token = booking.snap_token;
                                            if (token == null ||
                                                token.isEmpty) {
                                              print(
                                                  'Snap token is null or empty');
                                              MidtransService.showToast(
                                                  'Transaction Failed: Token is missing or empty',
                                                  true);
                                              return;
                                            }

                                            if (_midtrans == null) {
                                              print(
                                                  'MidtransSDK is not initialized');
                                              MidtransService.showToast(
                                                  'Transaction Failed: SDK is not initialized',
                                                  true);
                                              return;
                                            }

                                            await _midtrans?.startPaymentUiFlow(
                                                token: token);
                                          } catch (e) {
                                            print('Error starting payment: $e');
                                            MidtransService.showToast(
                                                'Transaction Failed', true);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        backgroundColor: primaryColor,
                                        colorText: Colors.white,
                                        buttonWidth: 0.33,
                                        buttonHeight: 0.055,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
