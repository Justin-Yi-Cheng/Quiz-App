import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Authorization/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const int duration = 1;
  double opacity = 0;
  bool openPositions = false;

  void changeOpacity() {
    Future.delayed(const Duration(seconds: duration), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
      });
    });
  }

  void changePositions() {
    Future.delayed(const Duration(seconds: duration), () {
      setState(() {
        openPositions = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    changeOpacity();
    changePositions();
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 136, 175, 1),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 88, 114, 1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: appHeight - 250,
            left: appWidth - 300,
            child: Transform.rotate(
              angle: 15,
              child: Container(
                width: 400,
                height: 400,
                color: const Color.fromRGBO(0, 88, 114, 1),
              ),
            ),
          ),
          AnimatedPositioned(
            top: appHeight * 0.35,
            left: openPositions ? appWidth * 0.35 : appWidth * 0.35 + 20,
            duration: const Duration(seconds: duration),
            curve: Curves.fastLinearToSlowEaseIn,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: duration),
              child: Text(
                "Welcome to",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 2,
              ),
            ),
          ),
          AnimatedPositioned(
            top: appHeight * 0.4,
            left: openPositions ? appWidth * 0.25 : appWidth * 0.25 - 20,
            duration: const Duration(seconds: duration),
            curve: Curves.fastLinearToSlowEaseIn,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: duration),
              child: Text(
                "GradeIQ",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 4.5,
              ),
            ),
          ),
          AnimatedPositioned(
            top: openPositions ? appHeight * 0.55 : appHeight * 0.55 + 20,
            left: appWidth * 0.275,
            duration: const Duration(seconds: duration),
            curve: Curves.fastLinearToSlowEaseIn,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: duration),
              child: GestureDetector(
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                child: IntrinsicHeight(
                  child: Container(
                    color: const Color.fromRGBO(255, 87, 51, 1),
                    width: 250,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Login With Google",
                          style: GoogleFonts.lexend(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
