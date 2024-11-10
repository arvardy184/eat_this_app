import 'package:intl/intl.dart';

class DateUtils {
  // Format UTC date string with custom format
  static String formatFromUTC(String? dateString, {String format = 'MMM d, y'}) {
    if (dateString == null) return '-';
    
    try {
      // Parse the UTC date string
      final DateTime utcDate = DateTime.parse(dateString);
      // Convert to local time
      final DateTime localDate = utcDate.toLocal();
      // Format using the specified format
      return DateFormat(format).format(localDate);
    } catch (e) {
      print('Error formatting date: $e');
      return dateString;
    }
  }

    static bool isToday(String? dateString) {
    if (dateString == null) return false;
    
    try {
      final DateTime utcDate = DateTime.parse(dateString);
      final DateTime localDate = utcDate.toLocal();
      final DateTime now = DateTime.now();
      
      return localDate.year == now.year && 
             localDate.month == now.month && 
             localDate.day == now.day;
    } catch (e) {
      print('Error checking if date is today: $e');
      return false;
    }
  }

  // Get start of today
  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Get end of today
  static DateTime endOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }


  // Format with default date and time

  static String formatDateTime(String? dateString) {
    return formatFromUTC(dateString, format: 'MMM d, y HH:mm');
  }

  // Format time only
  static String formatTimeOnly(String? dateString) {
    return formatFromUTC(dateString, format: 'HH:mm');
  }
  
  // Format date only
  static String formatDateOnly(String? dateString) {
    return formatFromUTC(dateString, format: 'MMM d, y');
  }

  // Get formatted local date with fallback
  static String getFormattedDate(String? dateString) {
    if (dateString == null) return DateFormat('MMM d, y').format(DateTime.now());
    return formatFromUTC(dateString);
  }
}