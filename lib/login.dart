import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Authorization/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  static const int duration = 1;
  double opacity = 0;

  void changeOpacity() {
    Future.delayed(const Duration(seconds: duration), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    animationController.forward();

    changeOpacity();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(seconds: duration),
            child: Center(
              child: Transform(
                transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
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
            ),
          ),
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(seconds: duration),
            child: Center(
              child: Transform(
                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
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
            ),
          ),
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(seconds: duration),
            child: Center(
              child: Transform(
                transform: Matrix4.translationValues(0.0, 60.0, 0.0),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                    },
                    child: IntrinsicHeight(
                      child: Container(
                        color: const Color.fromRGBO(255, 87, 51, 1),
                        width: 225,
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
            ),
          ),
        ],
      ),
    );
  }
}
