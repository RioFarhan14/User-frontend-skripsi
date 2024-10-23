import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/notifProvider.dart';
import 'package:user_frontend/utils/customAppBar.dart';
import 'package:user_frontend/utils/theme.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  int _activeCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.1),
        child: const CustomAppBar(title: 'Notifikasi'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationData, child) {
          final notifications = notificationData.notifications;
          final notifCategory = notificationData.notificationCategories;
          final notificationReads = notificationData.notificationReads;

          // Filter notifikasi berdasarkan kategori yang aktif
          final filteredNotifications = _activeCategoryIndex == -1
              ? notifications
              : notifications.where((notification) {
                  final categoryId =
                      notifCategory[_activeCategoryIndex]["category_id"];
                  return notification['category_id'] == categoryId;
                }).toList();

          return Column(
            children: [
              _buildCategoryButtons(
                  notifCategory, sizeWidth, sizeHeight, notificationData),
              Expanded(
                child: _buildNotificationList(filteredNotifications,
                    notificationReads, sizeWidth, sizeHeight, notificationData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryButtons(List notifCategory, double sizeWidth,
      double sizeHeight, NotificationProvider notificationData) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: sizeWidth * 0.02, vertical: sizeHeight * 0.01),
      child: SizedBox(
        height: sizeHeight * 0.05,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: notifCategory.length,
          itemBuilder: (context, index) {
            final notifCat = notifCategory[index];
            final isButtonPressed = _activeCategoryIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _activeCategoryIndex = isButtonPressed ? -1 : index;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        isButtonPressed ? Colors.grey : const Color(0xffF2F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      notifCat["category_name"] == "info"
                          ? const FaIcon(FontAwesomeIcons.circleInfo,
                              color: Colors.blue)
                          : const FaIcon(FontAwesomeIcons.tags,
                              color: Colors.orange),
                      SizedBox(width: sizeWidth * 0.02),
                      Text(
                        notifCat["category_name"],
                        style: GoogleFonts.poppins(
                          color: notifCat["category_name"] == "info"
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(
      List filteredNotifications,
      List<Map<String, dynamic>> notificationReads,
      double sizeWidth,
      double sizeHeight,
      NotificationProvider notificationData) {
    return Container(
      margin: EdgeInsets.only(top: sizeHeight * 0.01),
      width: sizeWidth * 0.9,
      child: ListView.builder(
        itemCount: filteredNotifications.length,
        itemBuilder: (context, index) {
          final notification = filteredNotifications[index];
          final getRead = _isNotificationRead(
              notification['notification_id'], notificationReads);
          final truncatedMessage = _truncateMessage(notification['message']);
          final readStatusText = getRead ? 'Sudah dibaca' : 'Belum dibaca';
          final opacity = getRead ? 0.5 : 1.0; // Set lower opacity if read
          return Opacity(
            opacity: opacity,
            child: InkWell(
              onTap: () {
                notificationData.isRead(notification['notification_id']);
                Navigator.pushNamed(context, '/detailInfo',
                    arguments: notification['notification_id']);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: sizeHeight * 0.02),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(sizeWidth * 0.03),
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
                    _buildNotificationHeader(
                        notification, sizeWidth, getRead, notification['time']),
                    SizedBox(height: sizeHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            truncatedMessage,
                            style: GoogleFonts.poppins(
                                color: blackColor, fontSize: sizeWidth * 0.035),
                          ),
                          SizedBox(height: sizeHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                readStatusText,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isNotificationRead(
      int notificationId, List<Map<String, dynamic>> notificationReads) {
    final readNotification = notificationReads.firstWhere(
        (item) => item['notification_id'] == notificationId,
        orElse: () => {});

    return readNotification.isNotEmpty && readNotification['is_read'] == true;
  }

  String _truncateMessage(String? message) {
    if (message == null) return '';
    return message.length > 60 ? '${message.substring(0, 60)}...' : message;
  }

  Widget _buildNotificationHeader(Map<String, dynamic> notification,
      double sizeWidth, bool getRead, String? time) {
    return Container(
      width: double.infinity, // Membuat header selebar tombol
      height: sizeWidth * 0.10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(sizeWidth * 0.03),
            topRight: Radius.circular(sizeWidth * 0.03)),
        color: notification["category_id"] == 1 ? Colors.blue : orangeColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizeWidth * 0.02, vertical: sizeWidth * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                notification["category_id"] == 1
                    ? const Icon(
                        Icons.info_outlined,
                        color: Colors.white,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.tags,
                        color: Colors.white,
                      ),
                SizedBox(width: sizeWidth * 0.02),
                Text(
                  notification['title'],
                  style: GoogleFonts.poppins(
                      color: whiteColor, fontSize: sizeWidth * 0.04),
                ),
              ],
            ),
            Text(
              time!,
              style: GoogleFonts.poppins(color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
