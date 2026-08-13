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
