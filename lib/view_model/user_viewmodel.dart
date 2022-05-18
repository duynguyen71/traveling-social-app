import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/User.dart';
import 'package:traveling_social_app/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;

  User? get user => _user;

  Future<User?> fetchUserDetail() async {
    final user = await _userService.getCurrentUserInfo();
    _user = user;
    notifyListeners();
    return _user;
  }

  void signOut() async {
    _user = null;
    _userService.signOut();
    notifyListeners();
  }

  bool equal(User? user) {
    if (user == null) {
      return true;
    }
    return _user == user;
  }
}
