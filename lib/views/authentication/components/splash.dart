import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('AULARE',
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 50,
              ))),
    );
  }
}
