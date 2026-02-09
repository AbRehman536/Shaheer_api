import 'package:flutter/cupertino.dart';
import 'package:shaheer_apis/models/user.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  String? _token;

  ///set User
  void setUser(UserModel model){
    _userModel = model;
    notifyListeners();
  }
  ///set Token
  void setToken(String val){
    _token = val;
    notifyListeners();
  }

  ///get User
  UserModel? getUser() => _userModel;
  ///get Token
  String? getToken() => _token;
}