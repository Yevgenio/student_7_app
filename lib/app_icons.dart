import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'config.dart';

class AppIcons {
  // Helper method to load an SVG asset
  static const double navbarIconSize = 24;

  static SvgPicture _icon(String assetName, {double size = 24, Color? color}) {
    return SvgPicture.asset(
      'lib/assets/icons/$assetName.svg',
      width: size,
      height: size,
      color: color,
    );
  }

  static SvgPicture _navbar_icon(String assetName, bool selected) {
    if(selected) {
      return _icon(assetName, size: navbarIconSize, color: AppTheme.secondaryColor);
    }
    else {
      return _icon(assetName, size: navbarIconSize, color: AppTheme.primaryColor);
    }
  }

  // Home Icons
  static SvgPicture homeSolid() {
    return _navbar_icon('home_solid', true);
  }

  static SvgPicture homeOutline() {
    return _navbar_icon('home_outline', false);
  }

  // Group Icons
  static SvgPicture groupSolid() {
    return _navbar_icon('chats_solid', true);
  }

  static SvgPicture groupOutline() {
    return _navbar_icon('chats_outline', false);
  }

  // Offers Icons
  static SvgPicture dealsSolid() {
    return _navbar_icon('deals_solid', true);
  }

  static SvgPicture dealsOutline() {
    return _navbar_icon('deals_outline', false);
  }

  // Search Icons
  static SvgPicture searchSolid() {
    return _navbar_icon('search_outline', true);
  }

  static SvgPicture searchOutline() {
    return _navbar_icon('search_outline', false);
  }

  // Profile Icons
  static SvgPicture profileSolid() {
    return _navbar_icon('profile_solid', true);
  }

  static SvgPicture profileOutline() {
    return _navbar_icon('profile_outline', false);
  }
}
