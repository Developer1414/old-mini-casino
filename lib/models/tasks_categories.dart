import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksCategories {
  List<PopupMenuEntry<String>> categories = [
    PopupMenuItem(
      value: 'Mines',
      child: Text(
        'Mines',
        style: GoogleFonts.roboto(
            color: Colors.black87.withOpacity(0.7),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ),
    PopupMenuItem(
      value: 'Limbo',
      child: Text(
        'Limbo',
        style: GoogleFonts.roboto(
            color: Colors.black87.withOpacity(0.7),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ),
    PopupMenuItem(
      value: 'Dice',
      child: Text(
        'Dice',
        style: GoogleFonts.roboto(
            color: Colors.black87.withOpacity(0.7),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ),
    PopupMenuItem(
      value: 'Fortune wheel',
      child: Text(
        'Fortune wheel',
        style: GoogleFonts.roboto(
            color: Colors.black87.withOpacity(0.7),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    )
  ];
}
