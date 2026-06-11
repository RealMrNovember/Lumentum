import 'package:flutter/foundation.dart';

class ShellNavigation extends ChangeNotifier {
  int _index = 1;

  int get index => _index;

  void goTo(int value) {
    if (_index == value) return;
    _index = value;
    notifyListeners();
  }
}
