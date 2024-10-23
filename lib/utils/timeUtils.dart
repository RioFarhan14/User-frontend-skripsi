// utils/time_utils.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> selectTime(
    BuildContext context, TextEditingController textTime) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (picked != null) {
    int pickedSeconds = picked.hour * 3600 + picked.minute * 60;
    int startTimeSeconds = 9 * 3600; // 9 pagi
    int endTimeSeconds = 21 * 3600; // 9 malam

    if (pickedSeconds >= startTimeSeconds && pickedSeconds <= endTimeSeconds) {
      textTime.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    } else {
      _showErrorDialog(context); // ignore: use_build_context_synchronously
    }
  }
}

Future<void> selectDate(
    BuildContext context, TextEditingController textDate) async {
  DateTime? picked = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 7)),
    initialDate: DateTime.now(),
  );

  if (picked != null) {
    textDate.text = picked.toString().split(" ")[0];
  }
}

void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ),
            const SizedBox(width: 13),
            Text(
              'Peringatan',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ],
        ),
        content: Text(
          'Pilih waktu antara 09:00 sampai 21:00',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
