import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  // Helper method to load an SVG asset
  static SvgPicture _icon(String assetName, {double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/$assetName.svg',
      width: size,
      height: size,
      color: color,
    );
  }

  // Home Icons
  static SvgPicture homeSolid({double size = 24, Color? color}) {
    return _icon('home_solid', size: size, color: color);
  }

  static SvgPicture homeOutline({double size = 24, Color? color}) {
    return _icon('home_outline', size: size, color: color);
  }

  // Group Icons
  static SvgPicture groupSolid({double size = 24, Color? color}) {
    return _icon('group_solid', size: size, color: color);
  }

  static SvgPicture groupOutline({double size = 24, Color? color}) {
    return _icon('group_outline', size: size, color: color);
  }

  // Offers Icons
  static SvgPicture offersSolid({double size = 24, Color? color}) {
    return _icon('deals_solid', size: size, color: color);
  }

  static SvgPicture offersOutline({double size = 24, Color? color}) {
    return _icon('deals_outline', size: size, color: color);
  }

  // Search Icons
  static SvgPicture searchSolid({double size = 24, Color? color}) {
    return _icon('deals_outline', size: size, color: color);
  }

  static SvgPicture searchOutline({double size = 24, Color? color}) {
    return _icon('deals_outline', size: size, color: color);
  }

  // Profile Icons
  static SvgPicture profileSolid({double size = 24, Color? color}) {
    return _icon('deals_outline', size: size, color: color);
  }

  static SvgPicture profileOutline({double size = 24, Color? color}) {
    return _icon('deals_outline', size: size, color: color);
  }
}
