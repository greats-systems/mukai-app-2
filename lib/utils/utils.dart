import 'dart:developer';

import 'package:intl/intl.dart';

Map<String, String>? _localizedStrings;

class Utils {
  static getTimeDifference(DateTime dateTime) {
    DateTime b = DateTime.now();

    Duration difference = b.difference(dateTime);

    log(difference.toString());

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    log("$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).");

    return days == 1
        ? '$days day ago'
        : days != 0
            ? '$days days ago'
            : hours == 1
                ? '$hours hour ago'
                : hours != 0
                    ? '$hours hours ago'
                    : minutes != 0
                        ? '$minutes minutes ago'
                        : seconds != 0
                            ? '$seconds days ago'
                            : '0 seconds ago';
  }

  static bool isToday(String dateString) {
    final date = DateTime.parse(dateString);
    final formattedDate = DateFormat.yMMMd().format(date);
    final todayFormattedDate = DateFormat.yMMMd().format(DateTime.now());

    return formattedDate == todayFormattedDate;
  }

  static getDateStringFromDateTime(DateTime dateTime,
      {bool showMonthShort = false}) {
    String date =
        dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day.toString();
    late String month;
    if (showMonthShort) {
      // month = dateTime.getMonthName();
    } else {
      month = dateTime.month < 10
          ? "0${dateTime.month}"
          : dateTime.month.toString();
    }

    String year = dateTime.year.toString();
    String separator = showMonthShort ? " " : "/";
    return "$date$separator$month$separator$year";
  }

  static getTimeStringFromDateTime(
    DateTime dateTime, {
    bool showSecond = true,
  }) {
    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute < 10
        ? "0${dateTime.minute}"
        : dateTime.minute.toString();
    String second = "";

    if (showSecond) {
      second = dateTime.second < 10
          ? "0${dateTime.second}"
          : dateTime.second.toString();
    }
    String meridian = "";
    meridian = dateTime.hour < 12 ? " AM" : " PM";

    return "$hour:$minute${showSecond ? ":" : ""}$second$meridian";
  }

  static String getDateTimeStringFromDateTime(DateTime dateTime,
      {bool showSecond = true,
      bool showDate = true,
      bool showTime = true,
      bool showMonthShort = false}) {
    if (showDate && !showTime) {
      return getDateStringFromDateTime(dateTime);
    } else if (!showDate && showTime) {
      return getTimeStringFromDateTime(dateTime, showSecond: showSecond);
    }
    return "${getDateStringFromDateTime(dateTime, showMonthShort: showMonthShort)} ${getTimeStringFromDateTime(dateTime, showSecond: showSecond)}";
  }

  static String getStorageStringFromByte(int bytes) {
    double b = bytes.toDouble(); //1024
    double k = bytes / 1024; //1
    double m = k / 1024; //0.001
    double g = m / 1024; //...
    double t = g / 1024; //...

    if (t >= 1) {
      return "${t.toStringAsFixed(2)} TB";
    } else if (g >= 1) {
      return "${g.toStringAsFixed(2)} GB";
    } else if (m >= 1) {
      return "${m.toStringAsFixed(2)} MB";
    } else if (k >= 1) {
      return "${k.toStringAsFixed(2)} KB";
    } else {
      return "${b.toStringAsFixed(2)} Bytes";
    }
  }

  static String formatDateTime(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = getMonthName(dateTime.month);
    String year = dateTime.year.toString();
    return "$day $month $year";
  }

  static String formatDateTimeYearMonth(DateTime dateTime) {
    String month = getMonthName(dateTime.month);
    String year = dateTime.year.toString();
    return "$month $year";
  }

  static String formatTime(DateTime dateTime) {
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return time;
  }

  static String getMonthName(int month) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[month - 1];
  }

  static List<dynamic> compareAndReturnList(dynamic value1, dynamic value2) {
    if (value1 == null && value2 == null) {
      return [null, null];
    } else if (value1 == null) {
      return [value2, value1];
    } else if (value2 == null) {
      return [value1, value2];
    } else if (value1 is num && value2 is num) {
      if (value1 < value2) {
        return [value1, value2];
      } else {
        return [value2, value1];
      }
    } else {
      throw ArgumentError('Both values must be numbers or null.');
    }
  }

  static String trimp(String text) {
    if (_localizedStrings != null) {
      String? value = _localizedStrings![text];
      return value ?? autoTranslate(text);
    }
    return autoTranslate(text);
  }

  static String autoTranslate(String text) {
    // log("You need to translate this text : " + text);
    at(text);

    try {
      // Split by both - and _ and flatten the list
      List<String> texts = text.split(RegExp(r'[-_]'));
      StringBuffer stringBuffer = StringBuffer();
      for (String singleText in texts) {
        if (singleText.isNotEmpty) {
          stringBuffer.write(
              "${singleText[0].toUpperCase()}${singleText.substring(1)} ");
        }
      }
      String result = stringBuffer.toString();
      return result.trim();
    } catch (err) {
      return text;
    }
  }

  static at(String t) async {
    // log("at");
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var data = sharedPreferences.getStringList('test_tr') ?? [];
    // var set = data.toSet();
    // set.add(t);
    // sharedPreferences.setStringList('test_tr', set.toList());
  }
}
