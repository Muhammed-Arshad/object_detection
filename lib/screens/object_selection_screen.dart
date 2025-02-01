import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/detection_provider.dart';
import 'camera_screen.dart';

class ObjectSelectionScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ObjectSelectionScreen({required this.cameras, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObjectDetectionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Select an Object')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ...['Laptop', 'Mobile', 'Mouse', 'Bottle'].map((object) => ListTile(
            title: Text(object),
            onTap: () {
              // Store the selected object
              provider.setSelectedObject(object.toLowerCase());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(cameras: cameras),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}