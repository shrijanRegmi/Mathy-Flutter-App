import "dart:async";
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/models/function/changeIndex.dart';
import 'package:mathy/models/function/music.dart';
import 'package:mathy/models/function/saveValues.dart';
import 'package:mathy/models/options.dart';
import 'package:mathy/screens/home/levels_screen.dart';
import 'package:mathy/screens/home/play_screen.dart';
import 'package:mathy/screens/widgets/drawer.dart';
import 'package:mathy/screens/widgets/optionsItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mathy/services/database/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _textColor = Color(0xff413D7A);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer _myAudioPlayer;

  bool _showWelcome = true;

  _handleAppStateChange(final SaveMyValues _saveValues) {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      switch (message) {
        case "AppLifecycleState.inactive":
          if (_myAudioPlayer != null && _saveValues.playingMusic) {
            PlayMusic().pauseMusic(_myAudioPlayer);
          }
          return null;
          break;
        case "AppLifecycleState.resumed":
          if (_myAudioPlayer != null && _saveValues.playingMusic) {
            PlayMusic().resumeMusic(_myAudioPlayer);
          }
          return null;
          break;
        default:
          return null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final _saveValue = Provider.of<SaveMyValues>(context, listen: false);
    _saveValue.initValue();
    _handleAppStateChange(_saveValue);

    Timer(Duration(seconds: 3), () async {
      setState(() {
        _showWelcome = false;
      });
      if (_myAudioPlayer == null && _saveValue.playingMusic) {
        final _result = await PlayMusic().playMusic();
        setState(() {
          _myAudioPlayer = _result;
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final _changeIndex = Provider.of<ChangeIndex>(context);
    final _user = Provider.of<UserDetail>(context);

    final _todaysDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final _refillDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    if (_user != null) {
      _changeIndex.changeIndex(_user.level, _user, "init", context);
      _changeIndex.completedQuestionsList(_user.level, false);

      // if (_user.refillDate == null) {
      //   DatabaseProvider(uid: _user.uid)
      //       .updateStats(refillDate: _refillDate.toString(), refill: true);
      // }

      if (_user.refillDate.contains("2")) {
        if (_todaysDate.isAtSameMomentAs(DateTime.parse(_user.refillDate)) ||
            _todaysDate.isAfter(DateTime.parse(_user.refillDate))) {
          DatabaseProvider(uid: _user.uid).updateStats(
              hintPoints: 5, refillDate: _refillDate.toString(), refill: true);
        }
      }
    }
  }

  @override
  void dispose() {
    if (_myAudioPlayer != null) {
      PlayMusic().disposeMusic(_myAudioPlayer);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userDetail = Provider.of<UserDetail>(context) ??
        UserDetail(userName: "Guest", userEmail: "I am a guest user", level: 0);
    final _topPlayers = Provider.of<List<UserDetail>>(context) ?? [];

    return Scaffold(
      backgroundColor: _textColor,
      key: _scaffoldKey,
      endDrawer: MyDrawer(_userDetail, _topPlayers, _myAudioPlayer),
      body: SafeArea(
        child: _showWelcome
            ? Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.polymer,
                        color: Colors.white,
                        size: 80.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("MATHY",
                          style:
                              TextStyle(color: Colors.white, fontSize: 45.0)),
                    ],
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    color: Color(0xfff3f3f3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _appBarSection(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _bodySection(),
                        _gameSection(),
                        _optionsList(),
                        SizedBox(
                          height: 100.0,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    left: 0.0,
                    right: 0.0,
                    child: AdmobBanner(
                      adUnitId:
                          "ca-app-pub-4056821571384483/5325355707", //real ad
                      // adUnitId:
                      //     "ca-app-pub-3940256099942544/6300978111", //test ad
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _appBarSection() {
    final _userDetail =
        Provider.of<UserDetail>(context) ?? UserDetail(userName: "Guest User");
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5.0,
              offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                child: Text(_userDetail.userName.substring(0, 1)),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                _userDetail.userName,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: _textColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
              // AuthProvider().signOutUser();
            },
            child: Container(
              width: 45.0,
              height: 40.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: Offset(0, 5)),
                ],
              ),
              child: SvgPicture.asset("images/menu.svg"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodySection() {
    return Expanded(child: LayoutBuilder(
      builder: (_, c) {
        return Container(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: c.maxHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          blurRadius: 10.0,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      "images/bg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  left: 50.0,
                  right: 50.0,
                  child: Center(
                    child: Text(
                      "Take your brain to the next level",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ));
      },
    ));
  }

  Widget _gameSection() {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Train your skills",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22.0, color: _textColor),
          ),
        ],
      ),
    );
  }

  Widget _optionsList() {
    final _saveValues = Provider.of<SaveMyValues>(context);
    return Container(
      height: 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: optionsList.length,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 50.0, bottom: 10.0),
              child: GestureDetector(
                  onTap: () {
                    return _navigationFunction(index, _saveValues);
                  },
                  child: OptionsItem(optionsList[index])),
            );
          } else if (optionsList[index].title == "Sound") {
            return GestureDetector(
              onTap: () {
                return _navigationFunction(index, _saveValues);
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: OptionsItem(optionsList[index]),
                  ),
                  _saveValues.playingMusic
                      ? Container()
                      : Positioned.fill(
                          child: Center(
                          child: Text("/",
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 100.0)),
                        )),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
                onTap: () {
                  return _navigationFunction(index, _saveValues);
                },
                child: OptionsItem(optionsList[index])),
          );
        },
      ),
    );
  }

  _navigationFunction(index, SaveMyValues _saveValues) async {
    switch (optionsList[index].title) {
      case "Play Now":
        return Navigator.push(
            context, MaterialPageRoute(builder: (_) => PlayScreenWrapper()));
        break;
      case "Levels":
        return Navigator.push(
            context, MaterialPageRoute(builder: (_) => LevelScreen()));
        break;
      case "Sound":
        if (_myAudioPlayer == null) {
          final _result = await PlayMusic().playMusic();
          setState(() {
            _myAudioPlayer = _result;
          });
          _saveValues.saveMusicState(true);
        } else {
          if (_saveValues.playingMusic) {
            PlayMusic().pauseMusic(_myAudioPlayer);
            _saveValues.saveMusicState(false);
          } else {
            PlayMusic().resumeMusic(_myAudioPlayer);
            _saveValues.saveMusicState(true);
          }
        }
        break;
      case "Share":
        break;
      default:
    }
  }
}
