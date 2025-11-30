import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    return getScreenWidth(context) >= 600 && getScreenWidth(context) < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static double getResponsiveValue(BuildContext context, 
      {double small = 1.0, double medium = 1.0, double large = 1.0}) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }

  static EdgeInsets getPadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 600) {
      return const EdgeInsets.all(16.0);
    } else if (width < 1200) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static double getCardHeight(BuildContext context) {
    final height = getScreenHeight(context);
    if (height < 600) {
      return 80.0;
    } else if (height < 800) {
      return 100.0;
    } else {
      return 120.0;
    }
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 600) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else {
      return 4;
    }
  }
}