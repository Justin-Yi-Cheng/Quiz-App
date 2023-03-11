import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Class Card
class ClassCard extends StatefulWidget {
  ClassCard({
    super.key,
    required this.courseName,
    required this.teacherName,
    required this.period,
  });

  final String courseName;
  final String teacherName;
  final String period;

  @override
  ClassCardState createState() => ClassCardState(
        courseName: courseName,
        teacherName: teacherName,
        period: period,
      );
}

class ClassCardState extends State<ClassCard> {
  ClassCardState({
    required this.courseName,
    required this.teacherName,
    required this.period,
  });

  final String courseName;
  final String teacherName;
  final String period;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$courseName - $period",
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 0.9,
              ),
              Text(
                teacherName,
                style: GoogleFonts.lexend(
                  color: const Color.fromRGBO(112, 128, 144, 1),
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 0.75,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------
// Assignment Card
class AssignmentCard extends StatelessWidget {
  AssignmentCard({
    required this.assignmentName,
  });

  final String assignmentName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => null,
      child: IntrinsicHeight(
        child: Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignmentName,
                  style: GoogleFonts.lexend(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 0.9,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
