import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum AppTheme { PurpleBrown, MandyRed, Amber, Wasabi, VesuviusBurn }

final appThemeData = {
  AppTheme.PurpleBrown: FlexColor.damask,
  AppTheme.MandyRed: FlexColor.bigStone,
  AppTheme.Amber: FlexColor.amber,
  AppTheme.Wasabi: FlexColor.green,
  AppTheme.VesuviusBurn: FlexColor.vesuviusBurn,
};
