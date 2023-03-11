import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_info.dart';
import 'widgets.dart';

/* To-Do List:
 * Find current computer time
 *   - If assignment past due date, assignment should have red border.
 *   - If teacher LOCKS assignment, then assignment cannot be accessed 
 *  
 * 
 * 
 * 
*/
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final Future firebaseInfo;

  @override
  void initState() {
    super.initState();
    firebaseInfo = getFirebaseInfo();
  }

  List<Color?> selectedClassColors = List.filled(6, Colors.white);
  int selectedClassIndex = 0;

  void setClassIndex(int index) {
    setState(() {
      selectedClassIndex = index;

      for (int i = 0; i < selectedClassColors.length; i++) {
        selectedClassColors[i] = Colors.white;
      }

      selectedClassColors[selectedClassIndex] = Colors.red;

      debugPrint("${selectedClassColors}");
    });
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 136, 175, 0.9),
      appBar: AppBar(
        elevation: 6.0,
        backgroundColor: const Color.fromRGBO(0, 136, 175, 1),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "GradeIQ",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.25,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(48, 48, 48, 0.85),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "Student-Name",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                ),
                textScaleFactor: 1,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: appWidth,
              height: 125,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: appWidth,
                      height: appWidth,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(245, 111, 70, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    width: appWidth,
                    top: appHeight * 0.025,
                    child: Text(
                      "Welcome",
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Student-Name",
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 2.6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 6.0),
                      child: Text(
                        "Classes",
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.3,
                      height: appHeight * 0.75,
                      child: FutureBuilder(
                        future: firebaseInfo,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            scrollDirection: Axis.vertical,
                            itemCount: courseData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => setClassIndex(index),
                                child: ClassCard(
                                  courseName: courseData[index]["Course-Name"],
                                  teacherName: courseData[index]
                                      ["Teacher-Name"],
                                  period: courseData[index]["Period"],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 6.0),
                      child: Text(
                        "Assignments",
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.3,
                      height: appHeight * 0.75,
                      child: FutureBuilder(
                        future: firebaseInfo,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            scrollDirection: Axis.vertical,
                            itemCount: courseData[selectedClassIndex]
                                    ["Assignments"]
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              return AssignmentCard(
                                assignmentName: courseData[selectedClassIndex]
                                    ["Assignments"][index]["Assignment-Name"],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
