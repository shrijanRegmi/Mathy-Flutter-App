import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathy/models/firebase/users.dart';

class DatabaseProvider {
  final String uid;
  DatabaseProvider({this.uid});

  final _ref = Firestore.instance;
  final _appName = "Mathy";

// send user detail
  Future sendUserDetail(final String _userName, final String _userEmail,
      final int _level, final int _hintPoints) async {
    try {
      final _result = await _ref
          .collection(_appName)
          .document("Users")
          .collection("Users")
          .document(uid)
          .setData({
        "uid": uid,
        "userName": _userName,
        "userEmail": _userEmail,
        "level": _level,
        "hintPoints": _hintPoints,
        "refillDate": DateTime.now().toString(),
      });
      return _result;
    } catch (e) {
      return e;
    }
  }

  Future updateStats(
      {final int level,
      final int hintPoints,
      final String refillDate,
      final bool refill}) async {
    if (level != null) {
      await _ref
          .collection(_appName)
          .document("Users")
          .collection("Users")
          .document(uid)
          .updateData({
        "level": level,
      });
    }

    if (hintPoints != null) {
      await _ref
          .collection(_appName)
          .document("Users")
          .collection("Users")
          .document(uid)
          .updateData({
        "hintPoints": hintPoints,
      });
    }

    if (refill != null && refill) {
      await _ref
          .collection(_appName)
          .document("Users")
          .collection("Users")
          .document(uid)
          .updateData({
        "refillDate": refillDate,
      });
    }
  }

/////////////////////////////////////////////////////////////get from firebase

// user detail from firebase
  UserDetail _userFromFirebase(DocumentSnapshot doc) {
    return UserDetail(
      uid: doc["uid"] ?? "",
      userName: doc["userName"] ?? "",
      userEmail: doc["userEmail"] ?? "",
      level: doc["level"] ?? 0,
      hintPoints: doc["hintPoints"] ?? 5,
      refillDate: doc["refillDate"] ?? DateTime.now().toString(),
    );
  }

// list of users from firebase
  List<UserDetail> _userListFromFirebase(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDetail(
        uid: doc["uid"],
        userName: doc["userName"],
        userEmail: doc["userEmail"],
        level: doc["level"],
      );
    }).toList();
  }

// get google login info if exist
  Future getGoogleIfExist() async {
    return await _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .get()
        .then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

////////////////////////////////////////////////////////////////streams

// stream of user detail
  Stream<UserDetail> get userDetail {
    return _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .document(uid)
        .snapshots()
        .map(_userFromFirebase);
  }

// stream of top players
  Stream<List<UserDetail>> get topPlayers {
    return _ref
        .collection(_appName)
        .document("Users")
        .collection("Users")
        .limit(50)
        .orderBy("level", descending: true)
        .snapshots()
        .map(_userListFromFirebase);
  }
}
