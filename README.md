# Object Detection Flutter App

## Overview
This is a Flutter-based object detection application that utilizes the `tflite_v2` package to detect selected objects using the device camera. The app allows users to choose an object, detect it in real-time, and capture an image when the object is properly positioned.

## Features
- Real-time object detection using TensorFlow Lite.
- Camera streaming with live bounding box display.
- Guidance for moving closer or farther from the object.
- Capturing and displaying detected objects.
- Uses `Provider` for state management.

## Installation & Running the App

### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Android Studio or Xcode (for iOS)
- A device or emulator with a camera

### Steps to Run
1. Clone the repository:
   ```sh
   git clone <repository_url>
   cd object_detection_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Ensure your device has a camera and run the app:
   ```sh
   flutter run
   ```

## Dependencies
- `flutter`: UI framework for cross-platform development.
- `camera`: For accessing the device camera.
- `provider`: State management solution.
- `tflite_v2`: For TensorFlow Lite integration.

## Challenges & Solutions
### 1. Camera Initialization Delay
**Issue:** The camera took time to initialize, causing delays.
**Solution:** Used `WidgetsFlutterBinding.ensureInitialized()` and checked `mounted` before setting state.

### 2. Object Detection Performance
**Issue:** Frequent lag in processing frames.
**Solution:** Used `_isProcessing` flag to avoid multiple detections at once.

### 3. Bounding Box Misalignment
**Issue:** The detected bounding box did not match the object location properly.
**Solution:** Adjusted scaling factors based on screen size to position the bounding box correctly.

## Future Improvements
- Add support for custom trained models.

## Demo Video
[Watch the demo video here](https://drive.google.com/file/d/17pVZODacJ5CA34lTt0Zy9GV16iCIcNT4/view?usp=sharing)

## License
This project is open-source. Feel free to use and modify it.





