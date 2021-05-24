import 'package:flutter/material.dart';
import 'package:pose_estimator/screens/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
          seconds: 5,
          navigateAfterSeconds: HomeScreen(),
          title: Text("Pose Estimation App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),),
      image: Image.asset("assets/icon.png"),
      backgroundColor: Colors.white,
      photoSize: 60,
      loaderColor: Colors.black,
      loadingText: Text("By M.U.K",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),),
    );
  }
}
