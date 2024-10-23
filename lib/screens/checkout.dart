import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/models/membership.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/providers/transactionProvider.dart';
import 'package:user_frontend/services/midtrans-service.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/theme.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late dynamic product;
  late int quantity;
  late int total;
  late Map<String, dynamic>? args;
  MidtransSDK? _midtrans;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initSDK(); // Memanggil fungsi untuk inisialisasi SDK
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      product = productProvider.getDataById(args!['product_id']);

      // Jika Anda mengetahui jenis produk, Anda bisa menggunakan pengecekan tipe
      if (product is Field) {
        // Handle Field
        Field fieldProduct = product as Field;
        quantity = int.tryParse(args!['duration']?.toString() ?? '1') ?? 1;
      } else if (product is Membership) {
        // Handle Membership
        Membership membershipProduct = product as Membership;
        quantity = int.tryParse(args!['quantity']?.toString() ?? '1') ?? 1;
      } else {
        // Tangani kasus jika product bukan Field atau Membership
        throw Exception('Unknown product type');
      }

      // Pastikan product.price dapat diubah menjadi integer jika perlu
      final productPrice = product.price?.toInt() ?? 0;
      total = quantity * productPrice as int;
    } else {
      // Tangani kasus jika args null
      throw Exception('Arguments are null');
    }
  }

  Future<void> _initSDK() async {
    _midtrans =
        await MidtransService.initializeSDK(context, MIDTRANS_CLIENT_KEY);
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
    final imageUrl = '$BASE_URL/images/${product.image}';
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: const CustomAppBar(title: 'Checkout'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
        padding: EdgeInsets.all(screenWidth * 0.07),
        width: screenWidth * 0.9,
        height: screenHeight * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    child: Image.network(
                      imageUrl,
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.35,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.05),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: quantity.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04),
                              ),
                              TextSpan(
                                text: ' x ',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04),
                              ),
                              TextSpan(
                                text: 'Rp ${product.price.toString()}',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Biaya',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.055),
                ),
                Text(
                  'Rp ${total.toString()}',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.055),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.07,
            ),
            CustomButton1(
              title: 'Bayar',
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              onPressed: () async {
                try {
                  final transactionProvider =
                      Provider.of<TransactionProvider>(context, listen: false);
                  final transaction =
                      await transactionProvider.createTransaction(args!);
                  final token = transaction?['snap_token'];

                  if (token == null) {
                    print('Snap token is null');
                    MidtransService.showToast(
                        'Transaction Failed: Token is null', true);
                    return;
                  }

                  await _midtrans?.startPaymentUiFlow(token: token);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false, // Menghapus semua rute sebelumnya
                  );
                } catch (e) {
                  print('Error starting payment: $e');
                  MidtransService.showToast('Transaction Failed', true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              backgroundColor: primaryColor,
              colorText: Colors.white,
              buttonWidth: 0.8,
              buttonHeight: 0.065,
            )
          ],
        ),
      ),
    );
  }
}
