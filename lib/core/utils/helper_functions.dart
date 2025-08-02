import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';

import 'package:intl/intl.dart';
bool validApiResponse(Response response) {
  if ((response.statusCode == 200) || (response.statusCode == 201)) {
    return true;
  } else {
    false;
  }
  return false;
}

int getColorValue(dynamic color) {
  if (color is int) {
    return color;
  } else if (color is String) {
    // Handle hex string (either with or without # prefix)
    final hexString =
        color.startsWith('#') ? '0xff${color.substring(1)}' : '0xff$color';
    return int.tryParse(hexString) ?? AppColors.primaryColor.value;
  }
  return AppColors.primaryColor.value;
}

Color getColorFromHex(String? hexColor) {
  try {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.grey; // fallback color
    }
    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // add alpha if not present
    }
    if (hex.length != 8) {
      return Colors.grey; // fallback for invalid length
    }
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    print('Error parsing color: $hexColor, $e');
    return Colors.grey; // fallback color
  }
}

  String getMonthName(String? month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    int index = int.tryParse(month ?? '') ?? 0;
    return (index >= 1 && index <= 12) ? months[index - 1] : '-';
  }

    String formattedDate(String? dateString) {
    try {
      if (dateString == null) return '';
      return DateFormat('dd-MM-yyyy – kk:mm')
          .format(DateTime.parse(dateString));
    } catch (_) {
      return dateString ?? '';
    }
  }
