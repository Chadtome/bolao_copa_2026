import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAdmin => _user?.isAdmin ?? false;

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
