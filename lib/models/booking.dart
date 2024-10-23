import 'package:flutter/material.dart';

class BookingItem {
  final String id;
  final String? client_name;
  final int product_id;
  final String? snap_token;
  final String statusBook;
  final String schedule;
  final String start_time;
  final String end_time;

  BookingItem({
    required this.id,
    this.client_name,
    this.snap_token,
    required this.product_id,
    required this.statusBook,
    required this.schedule,
    required this.start_time,
    required this.end_time,
  });

  factory BookingItem.fromJsonWithClientName(Map<String, dynamic> json) {
    return BookingItem(
      id: json['booking_id'] ?? '', // Menggunakan default jika null
      product_id: json['product_id'] ?? 0,
      client_name: json['user']?['name'] ?? '', // Menggunakan default jika null
      statusBook: json['status'] ?? '',
      schedule: json['booking_date'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
    );
  }

  factory BookingItem.fromJsonWithoutClientName(Map<String, dynamic> json) {
    return BookingItem(
      id: json['booking_id'] ?? '', // Menggunakan default jika null
      product_id: json['product_id'] ?? 0,
      snap_token: json['transaction']['snap_token'] ?? '',
      client_name: null, // Tidak ada client_name
      statusBook: json['status'] ?? '',
      schedule: json['booking_date'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
    );
  }
}
