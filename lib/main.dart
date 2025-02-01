import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:object_detection/provider/detection_provider.dart';
import 'package:object_detection/screens/object_selection_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ObjectDetectionProvider(),
      child: MyApp(cameras: cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({required this.cameras, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ObjectSelectionScreen(cameras: cameras),
    );
  }
}