import 'dart:async';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/models/function/changeIndex.dart';
import 'package:mathy/models/questions.dart';
import 'package:mathy/screens/home/correct_screen.dart';
import 'package:mathy/screens/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:mathy/services/database/database_provider.dart';
import 'package:provider/provider.dart';
import "package:mathy/models/function/show_dialogs.dart";
import 'package:admob_flutter/admob_flutter.dart';

class PlayScreenWrapper extends StatelessWidget {
  final int level;
  PlayScreenWrapper({this.level});
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    if (_user == null) {
      return PlayScreen(
        level: level,
      );
    }
    return StreamProvider<UserDetail>.value(
      value: DatabaseProvider(uid: _user.uid).userDetail,
      child: PlayScreen(
        level: level,
      ),
    );
  }
}

class PlayScreen extends StatefulWidget {
  final int level;
  PlayScreen({this.level});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  AdmobReward _admobReward;
  AdmobInterstitial _interStitial;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<double> _opacity = List.generate(10, (index) => 1.0);

  List<int> _invisibleIndex = [];

  final Color _textColor = Color(0xff413D7A);

  TextEditingController _controller = TextEditingController();

  String _ansState = "";

  bool _adLoaded = false;

  List<String> _randList = [];

  int _level;

  String _adType = "hint";

  int _adIndex;

  _getOptions() {
    final _changeIndex = Provider.of<ChangeIndex>(context, listen: false);
    if (_level != null || _changeIndex.index != gameQuestion.length) {
      var _rand = Random();
      setState(() {
        for (int i = 0;
            i <
                (10 -
                    gameQuestion[
                            _level == null ? _changeIndex.index : _level - 1]
                        .answer
                        .length);
            i++) {
          _randList.add(_rand.nextInt(10).toString());
        }

        for (int i = 0;
            i <
                gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                    .answer
                    .length;
            i++) {
          if (i !=
              (gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                      .answer
                      .length -
                  1)) {
            _randList.add(
                gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                    .answer
                    .substring(i, i + 1));
          } else {
            _randList.add(
                gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                    .answer
                    .substring(gameQuestion[_level == null
                                ? _changeIndex.index
                                : _level - 1]
                            .answer
                            .length -
                        1));
          }
        }
        _randList.shuffle();
      });
    }
  }

  _onAnsSubmitted(final UserDetail _user) {
    final _changeIndex = Provider.of<ChangeIndex>(context, listen: false);
    setState(() {
      if (_controller.text != "") {
        if (_controller.text.trim() ==
            gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                .answer) {
          _onAnsCorrect(_user);
        } else {
          _controller.clear();
          _ansState = "Wrong Ans. Try again !";
          for (int i = 0; i < _opacity.length; i++) {
            _opacity[i] = 1.0;
          }
        }
      }
    });
  }

  _onAnsCorrect(final UserDetail _user) async {
    final _changeIndex = Provider.of<ChangeIndex>(context, listen: false);
    var _haha = _level == null ? _changeIndex.index : _level - 1;
    Timer(Duration(milliseconds: 100), () {
      _controller.clear();
      if ((_level == null ? _changeIndex.index : _level - 1) <=
          (gameQuestion.length - 1)) {
        if (_haha == _changeIndex.index) {
          _changeIndex.changeIndex(_haha = _haha + 1, _user, "haha", context);
          _changeIndex.completedQuestionsList(_haha, false);
        }
      }
    });
    if (_user == null) {
      if ((_haha + 1) % 5 == 0) {
        if (await _interStitial.isLoaded) {
          _interStitial.show();
        }
      }
    } else {
      if ((_haha + 1) % 15 == 0) {
        if (await _interStitial.isLoaded) {
          _interStitial.show();
        }
      }
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CorrectScreen(
                level: _level != null ? _level + 1 : null,
                gameCompleted:
                    (_level == null ? _changeIndex.index : (_level - 1)) ==
                            (gameQuestion.length - 1)
                        ? true
                        : null)));
  }

  @override
  void initState() {
    super.initState();
    _admobReward = AdmobReward(
        adUnitId: "ca-app-pub-4056821571384483/4072532523", //real ad
        // adUnitId: "ca-app-pub-3940256099942544/5224354917", //test ad
        listener: (event, args) {
          _handleRewardEvent(event);
        });

    _interStitial = AdmobInterstitial(
        adUnitId: "ca-app-pub-4056821571384483/5138202186", //real ad
        // adUnitId: "ca-app-pub-3940256099942544/1033173712", //test ad
        listener: (event, args) {
          _handleInterStitialEvent(event);
        });

    _admobReward.load();
    _interStitial.load();
    _level = widget.level;
    _getOptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final _changeIndex = Provider.of<ChangeIndex>(context);
    // setState(() {
    //   _adIndex = _level == null ? _changeIndex.index : (_level - 1);
    // });
  }

  _handleRewardEvent(AdmobAdEvent event) {
    switch (event) {
      case AdmobAdEvent.loaded:
        setState(() {
          _adLoaded = true;
        });
        break;
      case AdmobAdEvent.rewarded:
        _admobReward.load();
        setState(() {
          _adLoaded = false;
        });
        if (_adIndex != null) {
          if (_adType == "hint") {
            ShowDialogs(context)
                .showUsedHintDialog(gameQuestion[_adIndex].hint);
          } else {
            ShowDialogs(context)
                .showUsedHintDialog(gameQuestion[_adIndex].solution);
          }
        }
        break;
      case AdmobAdEvent.closed:
        _admobReward.load();
        setState(() {
          _adLoaded = false;
        });
        break;
      case AdmobAdEvent.completed:
        _admobReward.load();
        setState(() {
          _adLoaded = false;
        });
        break;
      default:
        _admobReward.load();
        print("$event////////////////////////");
    }
  }

  _handleInterStitialEvent(AdmobAdEvent event) {
    switch (event) {
      case AdmobAdEvent.closed:
        _interStitial.load();
        break;
      case AdmobAdEvent.completed:
        _interStitial.load();
        break;
      default:
    }
  }

  @override
  void dispose() {
    _admobReward.dispose();
    _interStitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _changeIndex = Provider.of<ChangeIndex>(context);
    final _userDetail = Provider.of<UserDetail>(context);
    return _level == null && _changeIndex.index == gameQuestion.length
        ? CorrectScreen(
            gameCompleted: true,
          )
        : Scaffold(
            backgroundColor: _textColor,
            key: _scaffoldKey,
            body: SafeArea(
              child: Container(
                color: Color(0xfff3f3f3),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        MyAppBar(_level == null
                            ? "Level : ${_changeIndex.index + 1}"
                            : "Level : $_level"),
                        _userDetail == null
                            ? Container()
                            : Positioned.fill(
                                right: 20.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.lightbulb_outline,
                                              color: _textColor),
                                          onPressed: () async {
                                            ShowDialogs(context).showHintDialog(
                                                adhintFunction: () async {
                                                  setState(() {
                                                    _adType = "hint";
                                                    _adIndex = _level == null
                                                        ? _changeIndex.index
                                                        : (_level - 1);
                                                  });
                                                  if (await _admobReward
                                                      .isLoaded) {
                                                    _admobReward.show();
                                                  }
                                                },
                                                adsolutionFunction: () async {
                                                  setState(() {
                                                    _adType = "solution";
                                                    _adIndex = _level == null
                                                        ? _changeIndex.index
                                                        : (_level - 1);
                                                  });
                                                  if (await _admobReward
                                                      .isLoaded) {
                                                    _admobReward.show();
                                                  }
                                                },
                                                adLoaded: _adLoaded,
                                                hintFunction: () {
                                                  setState(() {
                                                    _adIndex = _level == null
                                                        ? _changeIndex.index
                                                        : (_level - 1);
                                                  });
                                                  if (_userDetail.hintPoints >=
                                                      1) {
                                                    ShowDialogs(context)
                                                        .showUsedHintDialog(
                                                            gameQuestion[
                                                                    _adIndex]
                                                                .hint);
                                                    DatabaseProvider(
                                                            uid:
                                                                _userDetail.uid)
                                                        .updateStats(
                                                            hintPoints: _userDetail
                                                                    .hintPoints -
                                                                1);
                                                  } else {
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "You don't have enough hint points. Come back tomorrow for more.")));
                                                  }
                                                },
                                                solutionFunction: () {
                                                  setState(() {
                                                    _adIndex = _level == null
                                                        ? _changeIndex.index
                                                        : (_level - 1);
                                                  });
                                                  if (_userDetail.hintPoints >=
                                                      3) {
                                                    ShowDialogs(context)
                                                        .showUsedHintDialog(
                                                            gameQuestion[
                                                                    _adIndex]
                                                                .solution);
                                                    DatabaseProvider(
                                                            uid:
                                                                _userDetail.uid)
                                                        .updateStats(
                                                            hintPoints: _userDetail
                                                                    .hintPoints -
                                                                3);
                                                  } else {
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "You don't have enough hint points. Come back tomorrow for more.")));
                                                  }
                                                },
                                                hintPoints:
                                                    _userDetail.hintPoints);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _questionSection(),
                    Text(
                      "$_ansState",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    _inputSection(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _questionSection() {
    final _changeIndex = Provider.of<ChangeIndex>(context);
    return Expanded(
      flex: 1,
      child: gameQuestion[_level == null ? _changeIndex.index : _level - 1]
              .question
              .contains("svg")
          ? SvgPicture.asset(
              gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                  .question,
            )
          : Image.asset(
              gameQuestion[_level == null ? _changeIndex.index : _level - 1]
                  .question),
    );
  }

  Widget _inputSection() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.black87,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _inputTop(),
            SizedBox(
              height: 30.0,
            ),
            _numbersList(),
            SizedBox(
              height: 10.0,
            ),
            _submitBtn(),
          ],
        ),
      ),
    );
  }

  Widget _inputTop() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Stack(
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            enabled: false,
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 10.0, right: 60.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (_controller.text != "") {
                              _controller.text = _controller.text
                                  .substring(0, _controller.text.length - 1);
                              _opacity[_invisibleIndex.last] = 1.0;
                              _invisibleIndex.removeLast();
                            }
                          });
                        },
                        icon: Icon(Icons.backspace, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numbersList() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _randList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (_, index) {
          return _numbersItem(int.parse(_randList[index]), index);
        });
  }

  Widget _numbersItem(int _level, int _index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_opacity[_index] != 0.0) {
            _controller.text += _level.toString();
            _opacity[_index] = 0.0;
            _invisibleIndex.add(_index);
            _ansState = "";
          }
        });
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: _opacity[_index],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black87,
              ),
              child: Center(
                child: Text("$_level",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          )),
    );
  }

  Widget _submitBtn() {
    final _user = Provider.of<UserDetail>(context);

    return RaisedButton.icon(
        onPressed: () {
          return _onAnsSubmitted(_user);
        },
        color: Colors.black87,
        textColor: Colors.white,
        icon: Icon(Icons.check_circle),
        label: Text("Submit"));
  }
}
