import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/user.dart';
import 'package:traveling_social_app/services/user_service.dart';

import '../models/file_upload.dart';

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

  void changeUserAvt(File file) async {
    FileUpload fileUpload = await _userService.updateAvt(file: file);
    _user!.avt = fileUpload.name.toString();
    notifyListeners();
  }

  void changeUserBackgroundPhoto(File file) async {
    FileUpload fileUpload = await _userService.updateBackground(file: file);
    _user!.background = fileUpload.name.toString();
    notifyListeners();
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
