import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/services/database/database_provider.dart';
import 'package:flutter/cupertino.dart';

class ChangeIndex extends ChangeNotifier {
  int _index = 0;
  List<int> _completedQuestionsList = [];

  void changeIndex(int i, final UserDetail _user, final _source,
      BuildContext context) async {
    _index = i;
    if (_source != "init" && _user != null) {
      DatabaseProvider(uid: _user.uid).updateStats(level: i);
    }
    notifyListeners();
  }

  void completedQuestionsList(int _val, bool _remove) {
    if (!_remove) {
      for (int i = 0; i <= _val; i++) {
        if (!_completedQuestionsList.contains(i)) {
          _completedQuestionsList.add(i);
        }
      }
    } else {
      _completedQuestionsList = [];
    }
    
    notifyListeners();
  }

  int get index => _index;
  List<int> get completedQuestionList => _completedQuestionsList;
}
