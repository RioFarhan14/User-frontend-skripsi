import 'package:flutter/material.dart';
import 'package:user_frontend/screens/activity/historyTransaction.dart';
import 'package:user_frontend/screens/activity/statusBooking.dart';
import 'package:user_frontend/widgets/InkwellAktivity.dart'; // Pastikan path ini benar

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        // Menu bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkwellActivity(
              title: 'Status Reservasi',
              left: true,
              onTap: () => _onTap(0),
              isActive: _selectedIndex == 0,
            ),
            InkwellActivity(
              left: false,
              title: 'Riwayat Transaksi',
              onTap: () => _onTap(1),
              isActive: _selectedIndex == 1,
            )
          ],
        ),
        // Content setelah menu bar
        Expanded(
          child: SizedBox(
              width: screenWidth,
              height: screenHeight * 0.63,
              child: _selectedIndex == 0
                  ? const StatusBooking()
                  : const HistoryTransaction()),
        ),
      ],
    );
  }
}
