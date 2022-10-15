import 'package:flutter/cupertino.dart';
import 'package:instagram/Models/user_model.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Authentication _authMethods = Authentication();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
