import 'dart:io';
import 'package:flutter/material.dart';

class ImageDisplayScreen extends StatelessWidget {
  final String imagePath;
  final String objectName;

  const ImageDisplayScreen({required this.imagePath,
    required this.objectName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Image')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              height: 500,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Object: $objectName', style: const TextStyle(fontSize: 18)),
                  Text('Date: ${DateTime.now().toLocal().toString().split(' ')[0]}'),
                  Text('Time: ${TimeOfDay.now().format(context)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}