import 'package:firebase_quiz_app/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'Authorization/google_sign_in.dart';

// Have to run using the specific port:
// flutter run -d chrome --web-hostname localhost --web-port 7357
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirebaseQuizApp());
}

class FirebaseQuizApp extends StatelessWidget {
  const FirebaseQuizApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Firebase Quiz App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const DashboardPage(),
        ),
      );
}
