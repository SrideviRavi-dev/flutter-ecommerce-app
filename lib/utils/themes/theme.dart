import 'package:flutter/material.dart';
import 'package:myapp/utils/themes/custom_themes.dart/appbar_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/bottom_sheet_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/check_box_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/chip_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/elevated_button.dart';
import 'package:myapp/utils/themes/custom_themes.dart/outlined_button_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/text_field_theme.dart';
import 'package:myapp/utils/themes/custom_themes.dart/text_theme.dart';


class JAppTheme{
  JAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme:JTextTheme.lightTextTheme ,
    chipTheme: JChipTheme.lightChipTheme,
    elevatedButtonTheme: JElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: JAppBarTheme.lightAppBarTheme,
    checkboxTheme: JCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: JBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: JOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: JTextFormFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData darkTheme = ThemeData(
     useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme:JTextTheme.darkTextTheme,
    chipTheme: JChipTheme.darkChipTheme,
    elevatedButtonTheme: JElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: JAppBarTheme.darkAppBarTheme,
    checkboxTheme: JCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: JBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: JOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: JTextFormFieldTheme.darkInputDecorationTheme,

  );
}