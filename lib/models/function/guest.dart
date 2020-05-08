import 'package:flutter/cupertino.dart';

class GuestUser extends ChangeNotifier {
  bool _guest = false;

  void enableGuest(final _result) {
    _guest = _result;
    notifyListeners();
  }

  bool get guest => _guest;
}
