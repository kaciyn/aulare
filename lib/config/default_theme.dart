import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//themes
const darkGrey = Color(0xff121212);
const darkerGrey = Color(0xff0D0D0D);
const lightBlack = Color(0xff191919);
const accentColour = Color(0xff009fc7);
const darkAccentColour = Color(0xff001d23);

const lightGrey = CupertinoColors.lightBackgroundGray;

final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: darkerGrey,
  primaryColor: lightBlack,
  textTheme: GoogleFonts.latoTextTheme()
      .apply(displayColor: Colors.grey[400], bodyColor: Colors.white),
  appBarTheme: AppBarTheme(
    elevation: 0,
    toolbarTextStyle: GoogleFonts.latoTextTheme()
        .apply(displayColor: Colors.grey[400], bodyColor: Colors.white)
        .bodyText2,
    titleTextStyle: GoogleFonts.latoTextTheme()
        .apply(displayColor: Colors.grey[400], bodyColor: Colors.white)
        .headline6,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColour),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: lightBlack,
  textTheme: GoogleFonts.latoTextTheme()
      .apply(displayColor: darkGrey, bodyColor: lightBlack),
  appBarTheme: AppBarTheme(
    elevation: 0,
    toolbarTextStyle: GoogleFonts.latoTextTheme()
        .apply(displayColor: darkGrey, bodyColor: lightBlack)
        .bodyText2,
    titleTextStyle: GoogleFonts.latoTextTheme()
        .apply(displayColor: darkGrey, bodyColor: lightBlack)
        .headline6,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColour),
);
