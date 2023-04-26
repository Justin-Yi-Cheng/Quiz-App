import 'package:firebase_quiz_app/firebase_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Class Card
// ignore: must_be_immutable
class ClassCard extends StatefulWidget {
  ClassCard({
    super.key,
    required this.courseName,
    required this.teacherName,
    required this.period,
    required this.selectedColor,
  });

  String courseName;
  String teacherName;
  String period;
  Color selectedColor;

  @override
  ClassCardState createState() => ClassCardState();
}

class ClassCardState extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: widget.selectedColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.courseName} - ${widget.period}",
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 0.9,
              ),
              Text(
                widget.teacherName,
                style: GoogleFonts.lexend(
                  color: const Color.fromRGBO(112, 128, 144, 1),
                ),
                textScaleFactor: 0.8,
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
// Add Progress Bar
// ignore: must_be_immutable
class AssignmentCard extends StatefulWidget {
  AssignmentCard({
    super.key,
    required this.assignmentName,
    required this.teacherName,
    required this.dueDate,
    required this.timeLimit,
    required this.questions,
    required this.isSubmitted,
    required this.selectedClassIndex,
  });

  String assignmentName;
  String teacherName;
  Timestamp dueDate;
  String timeLimit;
  Map<String, dynamic> questions;
  bool isSubmitted;
  int selectedClassIndex;

  @override
  AssignmentCardState createState() => AssignmentCardState();
}

class AssignmentCardState extends State<AssignmentCard> {
  bool isLate() {
    if (DateTime.now().isAfter(widget.dueDate.toDate())) {
      return true;
    }
    return false;
  }

  Color isLateColor() {
    if (isLate()) {
      return Colors.red;
    }

    return Colors.black;
  }

  String printDueDate() {
    DateFormat dateFormat = DateFormat("MM-dd");

    if (isLate()) {
      if (DateTime.now().day - widget.dueDate.toDate().day == 1) {
        return "1 Day Late";
      }

      return "${DateTime.now().day - widget.dueDate.toDate().day} Days Late";
    }

    return "Due ${dateFormat.format(widget.dueDate.toDate())}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setRefID(widget.teacherName, widget.assignmentName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentReviewScreen(
              assignmentName: widget.assignmentName,
              teacherName: widget.teacherName,
              dueDate: widget.dueDate,
              timeLimit: widget.timeLimit,
              questions: widget.questions,
              isSubmitted: widget.isSubmitted,
              selectedClassIndex: widget.selectedClassIndex,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            width: 1.5,
            color: isLateColor(),
          ),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.assignmentName,
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 0.9,
              ),
              Text(
                printDueDate(),
                style: GoogleFonts.lexend(
                  color: isLateColor(),
                ),
                textScaleFactor: 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------
// Assignment Review Screen
// ignore: must_be_immutable
class AssignmentReviewScreen extends StatefulWidget {
  AssignmentReviewScreen({
    super.key,
    required this.assignmentName,
    required this.teacherName,
    required this.dueDate,
    required this.timeLimit,
    required this.questions,
    required this.isSubmitted,
    required this.selectedClassIndex,
  });

  String assignmentName;
  String teacherName;
  Timestamp dueDate;
  String timeLimit;
  Map<String, dynamic> questions;
  bool isSubmitted;
  int selectedClassIndex;

  @override
  AssignmentReviewScreenState createState() => AssignmentReviewScreenState();
}

class AssignmentReviewScreenState extends State<AssignmentReviewScreen> {
  bool isLate() {
    if (DateTime.now().isAfter(widget.dueDate.toDate())) {
      return true;
    }
    return false;
  }

  Color isLateColor() {
    if (widget.isSubmitted == true) {
      return Colors.black;
    } else if (isLate()) {
      return Colors.red;
    }
    return Colors.black;
  }

  String isDue() {
    if (widget.isSubmitted == true) {
      return "Completed";
    } else if (isLate()) {
      return "Past Due";
    }

    return "Due";
  }

  String assignmentStart() {
    if (widget.isSubmitted == true) {
      return "Submitted";
    }

    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.questions["$i"]["Submitted-Answer"] != "") {
        return "In Progress";
      }
    }

    return "Start";
  }

  String assignmentComplete() {
    if (widget.isSubmitted == true) {
      return "View";
    }

    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.questions["$i"]["Submitted-Answer"] != "Undecided") {
        return "Continue";
      }
    }

    return "Get Started";
  }

  String printDueDate() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd - kk:mm:ss");
    return "Due ${dateFormat.format(widget.dueDate.toDate())}";
  }

  @override
  void initState() {
    super.initState();

    getFirebaseInfo().then((_) {
      // Reupdates information according to Firebase data
      for (int i = 0; i < courseData.length; i++) {
        if (courseData[i]["Teacher-Name"] == widget.teacherName) {
          Map<String, dynamic> assignment =
              courseData[i]["Assignments"]["$assignmentIndex"];

          setState(() {
            widget.assignmentName = assignment["Assignment-Name"];
            widget.dueDate = assignment["Due-Date"];
            widget.timeLimit = assignment["Time-Limit"];
            widget.questions = assignment["Questions"];
            widget.isSubmitted = assignment["Is-Submit"];
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Container(
                  width: 175,
                  height: 375,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 136, 175, 1),
                      width: 1.0,
                    ),
                    image: const DecorationImage(
                      image: AssetImage(
                        "Quiz-App-Wallpaper.jpg",
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 375,
                height: 375,
                child: Card(
                  elevation: 8.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.assignmentName,
                              style: GoogleFonts.lexend(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textScaleFactor: 1.75,
                            ),
                            const Spacer(),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                color: Color.fromRGBO(0, 136, 175, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  assignmentStart(),
                                  style: GoogleFonts.lexend(
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 0.85,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Assigned by ${widget.teacherName}",
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                          ),
                          textScaleFactor: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: Container(
                            width: 375,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: isLateColor(),
                                ),
                              ),
                              Text(
                                isDue(),
                                style: GoogleFonts.lexend(
                                  color: isLateColor(),
                                ),
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(52, 0, 0, 18),
                          child: Text(
                            printDueDate(),
                            style: GoogleFonts.lexend(
                              color: Colors.black,
                            ),
                            textScaleFactor: 0.85,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Icon(
                                  Icons.question_mark_rounded,
                                  color: Color.fromRGBO(135, 206, 250, 1),
                                ),
                              ),
                              Text(
                                "Content",
                                style: GoogleFonts.lexend(
                                  color: Colors.black,
                                ),
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(52, 0, 0, 18),
                          child: Text(
                            widget.questions.length > 1
                                ? "${widget.questions.length} Questions"
                                : "${widget.questions.length} Question",
                            style: GoogleFonts.lexend(
                              color: Colors.black,
                            ),
                            textScaleFactor: 0.85,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Icon(
                                  Icons.access_alarms_rounded,
                                  color: Color.fromRGBO(135, 206, 250, 1),
                                ),
                              ),
                              Text(
                                "Time Limit",
                                style: GoogleFonts.lexend(
                                  color: Colors.black,
                                ),
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(52, 0, 0, 10),
                          child: Text(
                            widget.timeLimit,
                            style: GoogleFonts.lexend(
                              color: Colors.black,
                            ),
                            textScaleFactor: 0.85,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
                          child: Container(
                            width: 375,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: widget.isSubmitted ? false : true,
                              child: OutlinedButton(
                                onPressed: () async => {
                                  await setCourseSubmission(),
                                  Navigator.pop(context),
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(224, 224, 224, 0.9),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Submit Assignment",
                                  style: GoogleFonts.lexend(
                                    color: const Color.fromRGBO(68, 68, 68, 1),
                                  ),
                                  textScaleFactor: 0.85,
                                ),
                              ),
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () async => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssignmentScreen(
                                      assignmentName: widget.assignmentName,
                                      timeLimit: widget.timeLimit,
                                      questions: widget.questions,
                                      isSubmitted: widget.isSubmitted,
                                    ),
                                  ),
                                ),
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(0, 136, 175, 1),
                                side: const BorderSide(
                                  color: Color.fromRGBO(0, 136, 175, 1),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                assignmentComplete(),
                                style: GoogleFonts.lexend(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 0.85,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentScreen extends StatefulWidget {
  AssignmentScreen({
    super.key,
    required this.assignmentName,
    required this.timeLimit,
    required this.questions,
    required this.isSubmitted,
  });

  String assignmentName;
  String timeLimit;
  Map<String, dynamic> questions;
  bool isSubmitted;

  @override
  AssignmentScreenState createState() => AssignmentScreenState();
}

class AssignmentScreenState extends State<AssignmentScreen> {
  List<String> answerChoiceList = ["A", "B", "C", "D", "E", "F", "G"];
  List<Map<int, Color>> selectedCircleMapList = [];
  List<Map<int, Color>> selectedLetterMapList = [];
  List<ValueNotifier<bool>> isAnsweredList = [];
  List<ValueNotifier<int?>> selectedAnswerIndexList = [];
  ValueNotifier<int> numAnswered = ValueNotifier(0);
  ValueNotifier<int> numCorrect = ValueNotifier(0);

  ValueNotifier<int> questionIndex = ValueNotifier(0);

  void setAnswerIndex(int questIndex, int index) {
    setState(() {
      selectedAnswerIndexList[questIndex].value = index;
      selectedCircleMapList[questIndex][index] =
          const Color.fromRGBO(0, 136, 175, 1);
      selectedLetterMapList[questIndex][index] = Colors.white;

      selectedCircleMapList[questIndex]
          .updateAll((key, value) => key != index ? Colors.white : value);
      selectedLetterMapList[questIndex]
          .updateAll((key, value) => key != index ? Colors.black : value);
    });
  }

  bool isCorrect(int index) {
    return widget.questions["$index"]["Correct-Answer"] ==
        widget.questions["$index"]["Submitted-Answer"];
  }

  Icon checkOrX(int index) {
    if (index ==
        int.parse(
            widget.questions["${questionIndex.value}"]["Correct-Answer"])) {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    return const Icon(Icons.close, color: Colors.red);
  }

  void checkCorrectAndAnswered() {
    // Counts number answered
    int numberAnswered = 0;
    for (int i = 0; i < isAnsweredList.length; i++) {
      if (isAnsweredList[i].value == true) numberAnswered++;
    }
    numAnswered.value = numberAnswered;

    // Counts number correct
    int numberCorrect = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (isCorrect(i)) numberCorrect += 1;
    }
    numCorrect.value = numberCorrect;
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.isSubmitted) {
        isAnsweredList.add(ValueNotifier(true));
      } else {
        isAnsweredList.add(
            ValueNotifier(widget.questions["$i"]["Submitted-Answer"] != ""));
      }

      for (int i = 0; i < widget.questions.length; i++) {
        Map<int, Color> blankSheet = {};
        Map<int, Color> blackSheet = {};

        for (int j = 0;
            j < widget.questions["$i"]["Answer-Choices"].length;
            j++) {
          blankSheet[j] = Colors.white;
          blackSheet[j] = Colors.black;
        }

        selectedCircleMapList.add(blankSheet);
        selectedLetterMapList.add(blackSheet);
      }
    }

    for (int i = 0; i < widget.questions.length; i++) {
      selectedAnswerIndexList.add(ValueNotifier(null));

      if (isAnsweredList[i].value &&
          widget.questions["$i"]["Submitted-Answer"] != "") {
        setAnswerIndex(
            i, int.parse(widget.questions["$i"]["Submitted-Answer"]));
      }
    }

    checkCorrectAndAnswered();
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
        title: AnimatedBuilder(
          animation: Listenable.merge([numAnswered, numCorrect]),
          builder: (BuildContext context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assignmentName,
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 3.0),
                          child: Text(
                            "Progress: ${numAnswered.value} / ${widget.questions.length}",
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                            ),
                            textScaleFactor: 0.6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                          child: Text(
                            "Accuracy: ${numCorrect.value} / ${numAnswered.value}",
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                            ),
                            textScaleFactor: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Visibility(
                  visible: widget.isSubmitted ? false : true,
                  child: OutlinedButton(
                    onPressed: () async => {
                      await setCourseSubmission(),
                      Navigator.pop(context),
                      Navigator.pop(context),
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(224, 224, 224, 0.9),
                      side: const BorderSide(
                        color: Color.fromRGBO(224, 224, 224, 1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Submit Assignment",
                      style: GoogleFonts.lexend(
                        color: const Color.fromRGBO(68, 68, 68, 1),
                      ),
                      textScaleFactor: 0.85,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: questionIndex,
        builder: (BuildContext context, _) {
          return AnimatedBuilder(
            animation: Listenable.merge(isAnsweredList),
            builder: (BuildContext context, _) {
              return AnimatedBuilder(
                animation: Listenable.merge(selectedAnswerIndexList),
                builder: (BuildContext context, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: appWidth * 0.3,
                          height: appHeight * 0.9,
                          child: Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              children: [
                                Container(
                                  width: appWidth * 0.3,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(224, 224, 224, 1),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          224, 224, 224, 1),
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.questions.length > 1
                                          ? "${widget.questions.length} Questions"
                                          : "${widget.questions.length} Question",
                                      style: GoogleFonts.lexend(
                                        color: Colors.black,
                                      ),
                                      textScaleFactor: 0.75,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: ListView.builder(
                                    itemCount: widget.questions.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          questionIndex.value = index;

                                          if (isAnsweredList[
                                                      questionIndex.value]
                                                  .value &&
                                              widget.questions[
                                                          "${questionIndex.value}"]
                                                      ["Submitted-Answer"] !=
                                                  "") {
                                            selectedAnswerIndexList[
                                                    questionIndex.value]
                                                .value = int.parse(widget
                                                        .questions[
                                                    "${questionIndex.value}"]
                                                ["Submitted-Answer"]);
                                          }
                                        },
                                        child: Container(
                                          width: appWidth * 0.3,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  83, 83, 83, 0.1),
                                            ),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    widget.questions["$index"]
                                                        ["Question-Title"],
                                                    style: GoogleFonts.lexend(
                                                      color: Colors.black,
                                                    ),
                                                    textScaleFactor: 0.75,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Visibility(
                                                  visible: isAnsweredList[index]
                                                      .value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 10, 0),
                                                    child: isCorrect(index)
                                                        ? const Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          )
                                                        : const Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                        child: SizedBox(
                          width: appWidth * 0.65,
                          height: appHeight * 0.9,
                          child: SingleChildScrollView(
                            child: Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: appWidth * 0.65,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          224, 224, 224, 1),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            224, 224, 224, 1),
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.questions[
                                                "${questionIndex.value}"]
                                            ["Question-Title"],
                                        style: GoogleFonts.lexend(
                                          color: Colors.black,
                                        ),
                                        textScaleFactor: 0.75,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: appWidth * 0.65,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            widget.questions[
                                                    "${questionIndex.value}"]
                                                ["Question-Image"],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget
                                        .questions["${questionIndex.value}"]
                                            ["Answer-Choices"]
                                        .length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (widget.isSubmitted) {
                                            return;
                                          }

                                          if (!isAnsweredList[
                                                  questionIndex.value]
                                              .value) {
                                            setAnswerIndex(
                                                questionIndex.value, index);
                                          }
                                        },
                                        child: Card(
                                          key: UniqueKey(),
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 12.0, 0),
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: selectedLetterMapList[
                                                                    questionIndex
                                                                        .value]
                                                                [index] ??
                                                            Colors.black,
                                                      ),
                                                      color: selectedCircleMapList[
                                                                  questionIndex
                                                                      .value]
                                                              [index] ??
                                                          Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        answerChoiceList[index],
                                                        style:
                                                            GoogleFonts.lexend(
                                                          color: selectedLetterMapList[
                                                                      questionIndex
                                                                          .value]
                                                                  [index] ??
                                                              Colors.black,
                                                        ),
                                                        textScaleFactor: 0.75,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  widget.questions[
                                                          "${questionIndex.value}"]
                                                      [
                                                      "Answer-Choices"]["$index"],
                                                  style: GoogleFonts.lexend(
                                                    color: Colors.black,
                                                  ),
                                                  textScaleFactor: 0.75,
                                                ),
                                                const Spacer(),
                                                Visibility(
                                                  visible: isAnsweredList[
                                                          questionIndex.value]
                                                      .value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 0, 20.0, 0),
                                                    child: checkOrX(index),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Visibility(
                                          visible: !isAnsweredList[
                                                  questionIndex.value]
                                              .value,
                                          child: OutlinedButton(
                                            onPressed: () async => {
                                              setAnswerSubmission(
                                                questionIndex.value,
                                                "${selectedAnswerIndexList[questionIndex.value].value}",
                                              ),
                                              widget.questions[
                                                          "${questionIndex.value}"]
                                                      ["Submitted-Answer"] =
                                                  "${selectedAnswerIndexList[questionIndex.value].value}",
                                              isAnsweredList[
                                                      questionIndex.value]
                                                  .value = true,
                                              checkCorrectAndAnswered(),
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 136, 175, 0.9),
                                              side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 136, 175, 1),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              "Submit Answer",
                                              style: GoogleFonts.lexend(
                                                color: Colors.white,
                                              ),
                                              textScaleFactor: 0.85,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
