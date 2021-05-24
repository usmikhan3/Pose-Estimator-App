import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double imgHeight;
  double imgWidth;
  List recognitionList;
  CameraImage imgCamera;
  CameraController cameraController;
  bool isWorking = false;

  void initCamera() {

    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if(!isWorking){
            isWorking = true;
            imgCamera = imageFromStream;
            runModelOnStreamFrame();
          }
        });
      });
    });
  }

  runModelOnStreamFrame() async{
    imgHeight = imgCamera.height + 0.0;
    imgWidth = imgCamera.width + 0.0;
    recognitionList = await Tflite.runPoseNetOnFrame(
      bytesList: imgCamera.planes.map((plane) {
        return plane.bytes;
      }).toList(),

      imageHeight: imgCamera.height,
      imageWidth: imgCamera.width,
      numResults: 2,


    );
    isWorking = false;
    setState(() {
      imgCamera;
    });
  }

  loadModel() async{
    Tflite.close();
    try{
      String response;
      response =  await Tflite.loadModel(model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
      print(response);
    }
    on PlatformException{
      print("Unable to load model");
    }
  }


  List<Widget> displayKeyPoints(Size screen){
    if(recognitionList == null || imgWidth == null) return [];
    if(imgHeight == null || imgWidth == null) return null;

    double factorX = screen.width;
    double factorY = imgHeight;

    var listAll = <Widget>[];

    recognitionList.forEach((result) {
      var list = result["keypoints"].values.map<Widget>((val){
        return Positioned(
          left: val["x"] * factorX -6,
          top: val["y"] * factorY -6,
          width: 100,
          height: 200,
          child: Text("◉ ${val['part']}",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            
          ),),
        );
      }).toList();
      listAll..addAll(list);
    });
return listAll;
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.stopImageStream();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidgets = [];

    stackChildrenWidgets.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height - 100,
            child: Container(
              height:size.height - 100,
              child: (!cameraController.value.isInitialized) ?
              Container() :
              AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            )
        )
    );

    
    if(imgCamera !=null){
      stackChildrenWidgets.addAll(displayKeyPoints(size));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Stack(
              children: stackChildrenWidgets,
          ),
          ),
        ),
      ),
    );
  }
}
