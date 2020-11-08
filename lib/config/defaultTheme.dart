import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//themes
const darkBlack = Color(0xff121212);
const lightBlack = Color(0xff191919);
const accentColour = Color(0xff009fc7);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: darkBlack,
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
      .apply(displayColor: darkBlack, bodyColor: lightBlack),
  appBarTheme: AppBarTheme(
    textTheme: GoogleFonts.latoTextTheme()
        .apply(displayColor: darkBlack, bodyColor: lightBlack),
    elevation: 0,
  ),
);