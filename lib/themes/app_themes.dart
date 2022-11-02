import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum AppTheme { PurpleBrown, MandyRed, Amber, Wasabi, VesuviusBurn }

final appThemeData = {
  AppTheme.PurpleBrown: FlexColor.redWine,
  AppTheme.MandyRed: FlexColor.bigStone,
  AppTheme.Amber: FlexColor.amber,
  AppTheme.Wasabi: FlexColor.dellGenoa,
  AppTheme.VesuviusBurn: FlexColor.vesuviusBurn,
};
