import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/transactionProvider.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:intl/intl.dart'; // Import intl package

class HistoryTransaction extends StatefulWidget {
  const HistoryTransaction({super.key});

  @override
  _HistoryTransactionState createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTransaction> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .getUserHistoryTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.isLoading) {
          return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF303B4C),
                    Color(0xFF101828),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(child: CircularProgressIndicator()));
        }

        final historys = transactionProvider.transactions;

        if (historys == null || historys.isEmpty) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenWidth * 0.05)),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF303B4C),
                    Color(0xFF101828),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                  child: Text(
                'Riwayat Transaksi Tidak Tersedia',
                style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )));
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF303B4C),
                Color(0xFF101828),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: ListView.builder(
            itemCount: historys.length,
            itemBuilder: (context, index) {
              final history = historys[index];

              final transactionDate =
                  DateTime.parse(history['transaction_date'])
                      .toLocal()
                      .toString() as String?;

              final status = history['status'] as String?;
              final productDetails =
                  history['transaction_details'] as List<dynamic>?;
              final productType =
                  productDetails != null && productDetails.isNotEmpty
                      ? (productDetails[0]['product']
                          as Map<String, dynamic>)['product_type'] as String?
                      : null;

              final productName = productDetails != null &&
                      productDetails.isNotEmpty
                  ? (productType == 'membership'
                      ? 'Membership'
                      : (productDetails[0]['product']
                          as Map<String, dynamic>)['product_name'] as String?)
                  : 'N/A';

              final schedule = transactionDate != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(transactionDate))
                  : 'N/A';
              final clock = transactionDate != null
                  ? DateFormat('HH:mm').format(DateTime.parse(transactionDate))
                  : 'N/A';

              return Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
                                topLeft: Radius.circular(screenWidth * 0.04),
                                topRight: Radius.circular(screenWidth * 0.04)),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF475467), Color(0xFF667085)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            height: sizeHeight * 0.2,
                            padding: EdgeInsets.only(left: sizeWidth * 0.05),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_available_outlined,
                                  color: primaryColor,
                                  size: sizeWidth * 0.07,
                                ),
                                SizedBox(width: sizeWidth * 0.01),
                                Text(
                                  'Riwayat Transaksi',
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Produk',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade800,
                                      fontSize: sizeHeight * 0.06,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: sizeHeight * 0.01),
                                Text(
                                  productName!,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: sizeHeight * 0.06,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  status ?? 'N/A',
                                  style: GoogleFonts.poppins(
                                      color: status == 'PAID'
                                          ? Colors.green
                                          : status == 'PENDING'
                                              ? Colors.orange
                                              : Colors.red,
                                      fontSize: sizeHeight * 0.06,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  schedule,
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
                          padding: EdgeInsets.only(left: sizeWidth * 0.05),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer_sharp,
                                color: orangeColor,
                                size: sizeHeight * 0.15,
                              ),
                              SizedBox(width: sizeWidth * 0.01),
                              Text(
                                clock,
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade800,
                                    fontSize: sizeHeight * 0.07,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
