import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//themes
const darkGrey = Color(0xff121212);
const darkerGrey = Color(0xff0D0D0D);
const lightBlack = Color(0xff191919);
const tealAccent = Color(0xff009fc7);
const darkAccentColour = Color(0xff00222f);
const mediumGrey = Color(0xffadadad);
const lightGrey = CupertinoColors.lightBackgroundGray;

class DarkTheme {
  // Color darkGrey;
  // Color darkerGrey;
  // Color lightBlack;
  // Color accentColour;
  // Color darkAccentColour;

  /// Default constructor
  DarkTheme();

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    final TextTheme textTheme = GoogleFonts.latoTextTheme()
        .apply(displayColor: Colors.grey[400], bodyColor: Colors.white);
    final AppBarTheme appBarTheme = AppBarTheme(
        elevation: 0,
        toolbarTextStyle: GoogleFonts.latoTextTheme()
            .apply(displayColor: Colors.grey[400], bodyColor: Colors.white)
            .bodyText2,
        titleTextStyle: GoogleFonts.latoTextTheme()
            .apply(displayColor: Colors.grey[400], bodyColor: Colors.white)
            .headline6);
    const Color textColor = lightGrey;
    final ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: Brightness.dark,
        primary: lightBlack,
        // primaryContainer: mediumGrey,
        secondary: tealAccent,
        secondaryContainer: darkAccentColour,
        background: darkerGrey,
        surface: darkerGrey,
        onBackground: lightGrey,
        onSurface: lightGrey,
        onError: Colors.white,
        onPrimary: lightGrey,
        onSecondary: mediumGrey,
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    final theme = ThemeData.from(textTheme: textTheme, colorScheme: colorScheme)
        .copyWith(appBarTheme: appBarTheme);

    /// Return the themeData which MaterialApp can now use
    return theme;
  }
}

final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: darkerGrey,
  primaryColor: lightBlack,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: tealAccent),
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
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: tealAccent),
);
