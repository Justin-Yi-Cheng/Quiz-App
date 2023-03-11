import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
final List<Map<String, dynamic>> courseData = [];

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
}
