import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int getCount() {
    return _count;
  }

  int incrementCount() {
    _count ++;
    notifyListeners();
  }

  int resetCount() {
    _count = 0;
    notifyListeners();
  }

  int minusCount() {
    _count --;
    notifyListeners();
  }
}