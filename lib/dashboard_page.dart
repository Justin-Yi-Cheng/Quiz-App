import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_info.dart';
import 'widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<int, Color> selectedMap = {};
  int selectedClassIndex = 0;
  late Future firebaseInfo;

  @override
  void initState() {
    super.initState();
    firebaseInfo = getFirebaseInfo();
    selectedMap[0] = const Color.fromRGBO(216, 216, 216, 1);
  }

  void setClassIndex(int index) {
    setState(() {
      selectedClassIndex = index;
      selectedMap[index] = const Color.fromRGBO(216, 216, 216, 1);

      selectedMap
          .updateAll((key, value) => key != index ? Colors.white : value);
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
              child: SizedBox(
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
                      child: StreamBuilder(
                        stream: firebaseInfo.asStream(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            key: UniqueKey(),
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
                                  selectedColor:
                                      selectedMap[index] ?? Colors.white,
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
                      width: appWidth * 0.7,
                      height: appHeight * 0.75,
                      child: StreamBuilder(
                          stream: firebaseInfo.asStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                              scrollDirection: Axis.vertical,
                              itemCount: courseData[selectedClassIndex]
                                      ["Assignments"]
                                  .length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2.75,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> assignment =
                                    courseData[selectedClassIndex]
                                        ["Assignments"]["$index"];

                                return AssignmentCard(
                                  assignmentName: assignment["Assignment-Name"],
                                  teacherName: courseData[selectedClassIndex]
                                      ["Teacher-Name"],
                                  dueDate: assignment["Due-Date"],
                                  timeLimit: assignment["Time-Limit"],
                                  questions: assignment["Questions"],
                                  isSubmitted: assignment["Is-Submit"],
                                  selectedClassIndex: selectedClassIndex,
                                );
                              },
                            );
                          }),
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
