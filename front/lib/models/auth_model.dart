import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when login
  Map<String, dynamic> appointment =
      {}; //update upcoming appointment when login
  List<Map<String, dynamic>> favteach = []; //get latest favorite teachtor
  List<dynamic> _fav = []; //get all fav teachtor id in list

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

//this is to update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

//and this is to return latest favorite teachtor list
  List<Map<String, dynamic>> get getFavteach {
    favteach.clear(); //clear all previous record before get latest list

    //list out teacher list according to favorite list
    for (var num in _fav) {
      for (var teach in user['teacher']) {
        if (num == teach['teach_id']) {
          favteach.add(teach);
        }
      }
    }
    return favteach;
  }

//when login success, update the status
  void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    //update all these data when login
    user = userData;
    appointment = appointmentInfo;
    if (user['details'] != null && user['details']['fav'] != null) {
      _fav = json.decode(user['details']['fav']);
    }

    notifyListeners();
  }
}
