import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/models/membership.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  String _membershipType = '1'; // State variable for radio button

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProductProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final memberships = Provider.of<ProductProvider>(context).memberships;

    // Handle empty memberships
    if (memberships.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Membership',
            style: GoogleFonts.poppins(color: whiteColor),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Opsi Membership Tidak Tersedia',
            style: GoogleFonts.poppins(fontSize: screenWidth * 0.05),
          ),
        ),
      );
    }

    Membership selectedMembership = memberships.firstWhere(
        (membership) => membership.id.toString() == _membershipType,
        orElse: () => memberships.first);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.25,
              color: primaryColor,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/membershipIcon.png',
                        width: screenWidth * 0.1,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Text(
                        'Membership',
                        style: GoogleFonts.poppins(
                            color: whiteColor, fontSize: screenWidth * 0.05),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Gabung Membership Kami dan Nikmati Keuntungan Eksklusif',
                    style: GoogleFonts.poppins(
                        color: whiteColor, fontSize: screenWidth * 0.03),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.075,
                left: screenWidth * 0.04,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/btn_back.png',
                  width: screenWidth * 0.12,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.25),
              width: screenWidth,
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keuntungan Membership',
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  // Benefits section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/discount.png',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Text(
                        'Potongan Harga',
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenWidth * 0.02),
                    child: Text(
                      'Potongan harga 20 % untuk Setiap pemesanan',
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/scheduleChange.png',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Text(
                        'Penjadwalan Ulang',
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenWidth * 0.02),
                    child: Text(
                      'Pengguna Dapat Menjadwalkan Ulang Pemesanan Sebelum Hari Pemesanan',
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/megaphone.png',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Text(
                        'Pengingat Waktu Pesanan',
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenWidth * 0.02),
                    child: Text(
                      'Pemberitahuan 10 Menit Sebelum Pesanan Dimulai',
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  // Membership options
                  ...memberships.map((membership) => Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          border: Border.all(width: 1),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${membership.name} Bulan',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.05),
                              ),
                              Text(
                                'Rp.${membership.price},-',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.05),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: membership.id.toString(),
                                groupValue: _membershipType,
                                onChanged: (value) {
                                  setState(() {
                                    _membershipType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _membershipType = membership.id.toString();
                            });
                          },
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/checkout',
            arguments: {
              'product_id': selectedMembership.id,
              'quantity': 1,
            },
          );
        },
        child: Container(
            width: screenWidth,
            color: primaryColor,
            height: screenHeight * 0.07,
            child: Center(
              child: Text(
                'Checkout',
                style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600),
              ),
            )),
      ),
    );
  }
}
