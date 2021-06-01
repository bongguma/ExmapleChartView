import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int getCount() {
    return _count;
  }

  int incrementCount() {
    _count ++;
    notifyListeners();  // 메서드 상태가 변경될 때 호출해 provider에 알린다.
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