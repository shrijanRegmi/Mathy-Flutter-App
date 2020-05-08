import 'package:audioplayers/audioplayers.dart';
import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/models/function/changeIndex.dart';
import 'package:mathy/models/function/guest.dart';
import 'package:mathy/models/function/music.dart';
import 'package:mathy/models/function/saveValues.dart';
import 'package:mathy/models/function/show_dialogs.dart';
import 'package:mathy/services/authentication/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mathy/services/database/database_provider.dart';

class MyDrawer extends StatefulWidget {
  final UserDetail _user;
  final List<UserDetail> _usersList;
  final AudioPlayer _myAudioPlayer;
  MyDrawer(this._user, this._usersList, this._myAudioPlayer);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _btnPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    final _guest = Provider.of<GuestUser>(context);
    final _saveValues = Provider.of<SaveMyValues>(context);

    final _changeIndex = Provider.of<ChangeIndex>(context);

    return Drawer(
      child: Container(
          color: Colors.blue,
          child: LayoutBuilder(
            builder: (_, constraints) {
              if (!_btnPressed) {
                return ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.blueAccent,
                      height: 180.0,
                      child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: Text(widget._user.userName.substring(0, 1),
                                style: TextStyle(
                                    fontSize: 32.0, color: Colors.white)),
                          ),
                          accountName: Text(widget._user.userName),
                          accountEmail: Text(widget._user.userEmail)),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 200),
                      color: Colors.deepPurple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          widget._user.userName == "Guest"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                        "Please log in to enjoy all the features.",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("Leaderboard",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      trailing: Icon(
                                        Icons.equalizer,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _btnPressed = true;
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Reset Level",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      trailing: Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        ShowDialogs(context).showAlertDialog(
                                            "Are you sure you want to reset all your progress ?",
                                            () {
                                          DatabaseProvider(uid: _user.uid)
                                              .updateStats(level: 0);
                                          _changeIndex.completedQuestionsList(
                                              0, true);
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Divider(
                                        color: Colors.white,
                                      ),
                                    ),
                                    ListTile(
                                        title: Text("Level Completed",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        trailing: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text("${widget._user.level}",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )),
                                    widget._user.hintPoints <= 0
                                        ? ListTile(
                                            title: Text(
                                                "Hint Points Refills On",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            trailing: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                  "${widget._user.refillDate.substring(0, 10)}",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ))
                                        : ListTile(
                                            title: Text("Hint Points",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            trailing: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                  "${widget._user.hintPoints}",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )),
                                  ],
                                ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                    widget._user.userName == "Guest"
                                        ? "Log in"
                                        : "Log out",
                                    style: TextStyle(color: Colors.white)),
                                trailing: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                onTap: () async {
                                  if (widget._myAudioPlayer != null &&
                                      _saveValues.playingMusic) {
                                    PlayMusic()
                                        .stopMusic(widget._myAudioPlayer);
                                  }
                                  Navigator.pop(context);
                                  if (_user != null) {
                                    AuthProvider().signOutUser();
                                  } else {
                                    _guest.enableGuest(false);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text("Rank",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                      ),
                      title: Text("Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      trailing: Text("Level",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(color: Colors.white),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget._usersList.length,
                          itemBuilder: (_, index) {
                            return StreamBuilder<UserDetail>(
                                stream: DatabaseProvider(
                                        uid: widget._usersList[index].uid)
                                    .userDetail,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListTile(
                                      leading: widget._usersList[index] ==
                                              widget._usersList.first
                                          ? Icon(Icons.star,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0, left: 7.0),
                                              child: Text("${index + 1}",
                                                  style: TextStyle(
                                                      fontWeight: widget
                                                                  ._usersList[
                                                                      index]
                                                                  .uid ==
                                                              _user.uid
                                                          ? FontWeight.bold
                                                          : FontWeight.w400,
                                                      color: widget
                                                                  ._usersList[
                                                                      index]
                                                                  .uid ==
                                                              _user.uid
                                                          ? Colors.black45
                                                          : Colors.white)),
                                            ),
                                      title: Text(
                                          widget._usersList[index].userName,
                                          style: TextStyle(
                                              fontWeight: widget
                                                          ._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)),
                                      trailing: Text("${snapshot.data.level}",
                                          style: TextStyle(
                                              fontWeight: widget
                                                          ._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                });
                          }),
                    ),
                  ],
                );
              }
            },
          )),
    );
  }
}
