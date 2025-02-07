import 'package:flutter/material.dart';

class AppStateModel extends ChangeNotifier {
  int currentindex =0;

  void changeIndex(int index){
    currentindex = index;
    notifyListeners();
  }  
}
