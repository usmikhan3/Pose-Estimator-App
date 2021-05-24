import 'package:flutter/material.dart';
import 'package:pose_estimator/screens/splah_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      home: MySplashScreen(),
    );
  }
}
//  keytool -genkey -v -keystore D:\APPLICATIONS\POSEESTIMATOR\keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
