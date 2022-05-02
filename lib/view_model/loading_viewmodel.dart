import 'package:flutter/cupertino.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = false;

  set setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  get isLoading  => _isLoading;
}
