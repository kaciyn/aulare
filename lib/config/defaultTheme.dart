import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//themes
const darkGrey = Color(0xff121212);
const darkerGrey = Color(0xff0D0D0D);
const lightBlack = Color(0xff191919);
const accentColour = Color(0xff009fc7);
const lightGrey = CupertinoColors.lightBackgroundGray;

final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: darkerGrey,
  primaryColor: lightBlack,
  primaryColorBrightness: Brightness.dark,
  accentColor: accentColour,
  textTheme: GoogleFonts.latoTextTheme()
      .apply(displayColor: Colors.grey[400], bodyColor: Colors.white),
  appBarTheme: AppBarTheme(
    textTheme: GoogleFonts.latoTextTheme()
        .apply(displayColor: Colors.grey[400], bodyColor: Colors.white),
    elevation: 0,
  ),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: lightBlack,
  primaryColorBrightness: Brightness.light,
  accentColor: accentColour,
  textTheme: GoogleFonts.latoTextTheme()
      .apply(displayColor: darkGrey, bodyColor: lightBlack),
  appBarTheme: AppBarTheme(
    textTheme: GoogleFonts.latoTextTheme()
        .apply(displayColor: darkGrey, bodyColor: lightBlack),
    elevation: 0,
  ),
);
