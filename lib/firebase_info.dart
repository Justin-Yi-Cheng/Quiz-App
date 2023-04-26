import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

final List<Map<String, dynamic>> courseData = [];
late int assignmentIndex;
late String refID;

Future getFirebaseInfo() async {
  await fire
      .collection('Courses')
      .where("Students", arrayContains: "223986522")
      .get()
      .then(
        (snapshot) => snapshot.docs.forEach(
          (document) {
            courseData.add(document.data());
          },
        ),
      );

  // Reoders the data according to period number
  for (int i = 0; i < courseData.length - 1; i++) {
    Map<String, dynamic> lowestPeriodData = courseData[i];
    int index = i;

    for (int j = i + 1; j < courseData.length; j++) {
      if (int.parse(courseData[j]["Period"]) <
          int.parse(lowestPeriodData["Period"])) {
        lowestPeriodData = courseData[j];
        index = j;
      }
    }

    courseData[index] = courseData[i];
    courseData[i] = lowestPeriodData;
  }
}

Future setRefID(String teacherName, String assignmentName) async {
  // Finds the specific assignment index
  for (int i = 0; i < courseData.length; i++) {
    if (courseData[i]["Teacher-Name"] == teacherName) {
      for (int j = 0; j < courseData[i]["Assignments"].length; j++) {
        if (courseData[i]["Assignments"]["$j"]["Assignment-Name"] ==
            assignmentName) {
          assignmentIndex = j;
        }
      }
    }
  }

  // Finds the specific document
  await fire
      .collection('Courses')
      .where("Students", arrayContains: "223986522")
      .where("Teacher-Name", isEqualTo: teacherName)
      .get()
      .then(
        (snapshot) => refID = snapshot.docs[0].id,
      );
}

Future setCourseSubmission() async {
  await fire.collection("Courses").doc(refID).update({
    "Assignments.$assignmentIndex.Is-Submit": true,
  });

  courseData.clear();
  await getFirebaseInfo();
}

Future setAnswerSubmission(int questionIndex, String submittedAnswer) async {
  await fire.collection("Courses").doc(refID).update({
    "Assignments.$assignmentIndex.Questions.$questionIndex.Submitted-Answer":
        submittedAnswer,
  });

  courseData.clear();
  await getFirebaseInfo();
}
