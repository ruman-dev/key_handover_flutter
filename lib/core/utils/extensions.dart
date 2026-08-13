import 'package:flutter/material.dart';

extension ContextSizeExtension on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Responsive width based on screen percentage
  double widthP(double percentage) => screenWidth * percentage;

  // Responsive height based on screen percentage
  double heightP(double percentage) => screenHeight * percentage;
}

extension ContextThemeExtension on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension StringDateExtension on String {
  String toFormattedDate(BuildContext context) {
    try {
      final date = DateTime.parse(this);
      final now = DateTime.now();
      final timeStr = TimeOfDay.fromDateTime(date).format(context);

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return 'Today, $timeStr';
      }

      final tomorrow = now.add(const Duration(days: 1));
      if (date.year == tomorrow.year &&
          date.month == tomorrow.month &&
          date.day == tomorrow.day) {
        return 'Tomorrow, $timeStr';
      }

      // Use basic formatting since we don't have intl imported here easily, 
      // or we can just import intl at the top. Let's do it simply without intl to avoid import issues.
      final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      final monthStr = months[date.month - 1];
      final dayStr = date.day.toString().padLeft(2, '0');
      return '$monthStr $dayStr, ${date.year}, $timeStr';
    } catch (_) {
      return this; // Return original if parsing fails
    }
  }
}
