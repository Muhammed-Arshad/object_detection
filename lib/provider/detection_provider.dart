import 'package:flutter/cupertino.dart';

class ObjectDetectionProvider extends ChangeNotifier {
  String? _selectedObject;

  String _moveGuidance = '';
  String _message = '';
  String get moveGuidance => _moveGuidance;
  String get message => _message;

  double _x = 0.0;
  double _y = 0.0;
  double _w = 0.0;
  double _h = 0.0;
  var label = '';


  String? get selectedObject => _selectedObject;
  double get x => _x;
  double get y => _y;
  double get w => _w;
  double get h => _h;

  void setBox(x,y,w,h){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    notifyListeners();
  }

  setMoveGuidance({guidance,String msg = ''}){
    _moveGuidance = guidance;
    _message = msg;
    notifyListeners();
  }

  void setSelectedObject(String object) {
    _selectedObject = object;
    notifyListeners();
  }

  clearData(){
    _message = '';
    _moveGuidance = '';
    _selectedObject = '';
    _x = 0.0;
    _y = 0.0;
    _w = 0.0;
    _h = 0.0;
  }
}