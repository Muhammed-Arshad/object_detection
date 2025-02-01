import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tflite_v2/tflite_v2.dart';
// import 'package:tflite/tflite.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
import '../provider/detection_provider.dart';
import 'image_display_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({required this.cameras, super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isProcessing = false;
  String _message = "Detecting...";
  // String _move = "ARSHAD ... move";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }


  void _initializeCamera() {

    _controller = CameraController(
        widget.cameras.first,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420
    );
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.startImageStream((CameraImage image) {
        _processFrame(image);
      });
    });
  }

  Future<void> _loadModel() async {

    String? res = await Tflite.loadModel(
      // model: "assets/mobilenet_v1_1.0_224.tflite",
        model: "assets/ssd_mobilenet.tflite",
        // labels: "assets/mobilenet_v1_1.0_224.txt",
        labels: "assets/ssd_mobilenet.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false
    );
    print("Model loading result: $res");
  }




  void _processFrame(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    var provider = Provider.of<ObjectDetectionProvider>(context, listen: false);

    var recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      model: "SSDMobileNet",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResultsPerClass: 1,
      threshold: 0.4,
      asynch: true,
    );

    if (recognitions != null && recognitions.isNotEmpty &&
        recognitions.first['detectedClass'] == provider.selectedObject) {
      var detectedObject = recognitions.first;

      if (detectedObject['confidenceInClass'] * 100 > 50) {
        provider.setBox(
          detectedObject['rect']['x'],
          detectedObject['rect']['y'],
          detectedObject['rect']['w'],
          detectedObject['rect']['h'],
        );

        provider.label = detectedObject['detectedClass'];

        // Define thresholds for guidance
        const double minSizeThreshold = 0.2; // Object too far
        const double maxSizeThreshold = 0.6; // Object too close

        double objectWidth = detectedObject['rect']['w'];
        double objectHeight = detectedObject['rect']['h'];

        if (objectWidth < minSizeThreshold || objectHeight < minSizeThreshold) {

          provider.setMoveGuidance(guidance: "Move closer to the object");
        } else if (objectWidth > maxSizeThreshold || objectHeight > maxSizeThreshold) {

          provider.setMoveGuidance(guidance: "Move farther from the object");
        } else {

          provider.setMoveGuidance(guidance: '',msg: 'Object in position\nPlease hold on for 3 seconds');
          await Future.delayed(Duration(seconds: 3));
          _captureImage();
          return;
        }
      }
    } else {
      provider.setMoveGuidance(guidance: '',msg: "Detecting ${provider.selectedObject}");
    }

    _isProcessing = false;
  }



  void _captureImage() async {
    try {
      final image = await _controller.takePicture();
      final provider = Provider.of<ObjectDetectionProvider>(context, listen: false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplayScreen(
            imagePath: image.path,
            objectName: provider.selectedObject.toString(),
          ),
        ),
      );

      await Future.delayed(Duration(seconds: 2));
      provider.clearData();


    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Object Detection')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          Consumer<ObjectDetectionProvider>(
              builder: (context, provider, child) {

                // print("ARSHAD 20 ${provider.x}");

                return Positioned(
                  top: (provider.y) * 700,
                  right: (provider.x) * 500,
                  child: Container(
                    width: provider.w * 100 * size.width/100,
                    height: provider.h * 100 * size.height/100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green,width: 4)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text(provider.label),
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Consumer<ObjectDetectionProvider>(
              builder: (context, provider, child) {
        return Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // _message,
                    provider.message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),Text(
                    provider.moveGuidance,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );}),
          ),
        ],
      ),
    );
  }
}