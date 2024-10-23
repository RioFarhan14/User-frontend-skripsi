import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/theme.dart';

class BookingFieldPage extends StatelessWidget {
  const BookingFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    // Mengambil data fields dan status loading
    final productProvider = Provider.of<ProductProvider>(context);
    final fields = productProvider.fields;
    final isLoading = productProvider.isLoading;

    // Memanggil fetchFields jika data belum ada
    if (fields.isEmpty && !isLoading) {
      productProvider.fetchData();
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Pilih Lapangan'),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Menampilkan loading indicator
          : Padding(
              padding: EdgeInsets.only(top: sizeHeight * 0.05),
              child: Center(
                child: SizedBox(
                  width: sizeWidth * 0.9,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing:
                          sizeWidth * 0.05, // Spacing between columns
                      mainAxisSpacing:
                          sizeHeight * 0.03, // Spacing between rows
                      childAspectRatio: 0.8, // Ratio for each item
                    ),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      final field = fields[index];
                      final imageUrl = '$BASE_URL/images/${field.image}';
                      return Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(sizeWidth * 0.02)),
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
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sizeWidth * 0.05),
                              ),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: sizeHeight * 0.12,
                                fit: BoxFit
                                    .cover, // Mengubah fit untuk menjaga rasio aspek
                              ),
                            ),
                            SizedBox(height: sizeHeight * 0.01),
                            Padding(
                              padding: EdgeInsets.only(left: sizeWidth * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    field.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: sizeWidth * 0.04,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: sizeHeight * 0.005),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Rp.${field.price},- ',
                                      style: GoogleFonts.poppins(
                                        fontSize: sizeWidth * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '/ Jam',
                                          style: GoogleFonts.poppins(
                                            fontSize: sizeWidth * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: orangeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        sizeWidth * 0.02),
                                              )),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/detailBook',
                                                arguments: field.id);
                                          },
                                          child: Text('Pesan',
                                              style: GoogleFonts.poppins(
                                                fontSize: sizeWidth * 0.03,
                                                fontWeight: FontWeight.bold,
                                                color: whiteColor,
                                              ))),
                                      SizedBox(width: sizeWidth * 0.03),
                                    ],
                                  )
                                ],
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
    );
  }
}
