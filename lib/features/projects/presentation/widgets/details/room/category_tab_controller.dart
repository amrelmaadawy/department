import 'package:flutter/material.dart';

class CategoryTabController extends ChangeNotifier {
  int _currentIndex = 0;
  int _totalTabs = 0;

  int get currentIndex => _currentIndex;
  int get totalTabs => _totalTabs;
  bool get isLastTab => _totalTabs > 0 && _currentIndex == _totalTabs - 1;

  void setTotalTabs(int total) {
    if (_totalTabs != total) {
      _totalTabs = total;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextTab() {
    if (!isLastTab) {
      setIndex(_currentIndex + 1);
    }
  }
}
