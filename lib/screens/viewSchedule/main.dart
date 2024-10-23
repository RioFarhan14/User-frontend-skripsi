import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/bookingProvider.dart';
import 'package:user_frontend/providers/productProvider.dart';
import 'package:user_frontend/utils/constants.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/customBotton1.dart';
import 'package:user_frontend/utils/customTextField1.dart';
import 'package:user_frontend/utils/theme.dart';
import 'package:user_frontend/utils/timeUtils.dart';

class ViewSchedulePage extends StatefulWidget {
  const ViewSchedulePage({Key? key}) : super(key: key);

  @override
  State<ViewSchedulePage> createState() => _ViewSchedulePageState();
}

class _ViewSchedulePageState extends State<ViewSchedulePage> {
  late TextEditingController textDate = TextEditingController();
  int? _selectedField;

  @override
  Widget build(BuildContext context) {
    final fieldData = Provider.of<ProductProvider>(context);
    final bookingProvider =
        Provider.of<BookingProvider>(context); // Perbaikan nama variabel
    final fields = fieldData.fields;
    final isLoading = fieldData.isLoading;

    // Memanggil fetchFields jika data belum ada
    if (fields.isEmpty && !isLoading) {
      fieldData.fetchData();
    }
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Lihat Jadwal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Lapangan',
              style: GoogleFonts.poppins(
                  fontSize: sizeWidth * 0.05, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: sizeWidth * 0.03, vertical: sizeHeight * 0.015),
              height: sizeHeight * 0.21,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  final isSelected = _selectedField == field.id;
                  final imageUrl = '$BASE_URL/images/${field.image}';
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedField = field.id;
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: sizeWidth * 0.05),
                      width: sizeWidth * 0.5,
                      height: sizeHeight * 0.21,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF101828), Color(0xFF303B4C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(sizeWidth * 0.04),
                        border: isSelected
                            ? Border.all(color: primaryColor, width: 3)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sizeWidth * 0.04)),
                            child: Image.network(
                              imageUrl,
                              width: sizeWidth,
                              height: sizeHeight * 0.15,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: sizeWidth * 0.03, left: sizeWidth * 0.04),
                            child: Text(
                              field.name,
                              style: GoogleFonts.poppins(
                                  fontSize: sizeWidth * 0.045,
                                  color: whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: sizeHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal',
                    style: GoogleFonts.poppins(
                      fontSize: sizeWidth * 0.04,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.01,
                  ),
                  CustomTextField1(
                    controller: textDate,
                    fieldHeight: 0.06,
                    fontSize: sizeWidth * 0.04,
                    fieldWidth: 0.8,
                    readOnly: true,
                    backgroundColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.event_note_outlined),
                    onTap: () {
                      selectDate(context, textDate);
                    },
                  ),
                  SizedBox(
                    height: sizeHeight * 0.02,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton1(
                          title: 'Cari',
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            if (_selectedField != null &&
                                textDate.text.isNotEmpty) {
                              _showTable(context, bookingProvider);
                              // Perbaikan nama variabel
                            }
                          },
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          fontSize: sizeWidth * 0.045,
                          buttonWidth: 0.25,
                          buttonHeight: 0.056,
                        ),
                      ]),
                  SizedBox(
                    height: sizeHeight * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTable(BuildContext context, BookingProvider bookingProvider) async {
    final textDateValue = textDate.text;
    final dateParts = textDateValue.split('-');

    // Pastikan format tanggal sesuai dengan yang diharapkan (YYYY-MM-DD)
    if (dateParts.length == 3 &&
        dateParts[0].length == 4 &&
        dateParts[1].length == 2 &&
        dateParts[2].length == 2) {
      // Parse tahun, bulan, dan hari dari string tanggal
      final year = int.tryParse(dateParts[0]);
      final month = int.tryParse(dateParts[1]);
      final day = int.tryParse(dateParts[2]);

      // Periksa apakah parsing berhasil
      if (year != null && month != null && day != null) {
        // Buat string tanggal dengan format "YYYY-MM-DD"
        final selectedDate =
            '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        print(_selectedField!);
        print(selectedDate);
        try {
          final bookings = await bookingProvider.fetchBookingsByDate(
              _selectedField!, selectedDate);

          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                      MediaQuery.of(context).size.width * 0.05)),
            ),
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.34,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Nama Pemesan',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Waktu',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                    rows: bookings.map((booking) {
                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                          if (bookings.indexOf(booking) % 2 == 0) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null;
                        }),
                        cells: [
                          DataCell(
                            Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.01),
                              child: Text(
                                booking.client_name ?? '',
                                style: GoogleFonts.poppins(fontSize: 14.0),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${booking.start_time} - ${booking.end_time}',
                                style: GoogleFonts.poppins(fontSize: 14.0),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(), // Tambahkan .toList() pada hasil map
                  ),
                ),
              );
            },
          );
        } catch (e) {
          // Tangani error jika ada
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat data: $e'),
            ),
          );
        }
      }
    }
  }
}
