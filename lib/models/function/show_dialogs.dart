import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowDialogs {
  BuildContext context;
  ShowDialogs(this.context);

  Future showHintDialog({
    final Function hintFunction,
    final Function solutionFunction,
    final Function adhintFunction,
    final Function adsolutionFunction,
    final bool adLoaded,
    final int hintPoints,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      child: Text(
                        "Your hint points : $hintPoints",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            hintFunction();
                          },
                          color: Colors.black87,
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                "Use 1 hint point for hint",
                                style: TextStyle(color: Colors.white),
                              ))),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            solutionFunction();
                          },
                          color: Colors.black87,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Use 3 hint points for solution",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    !adLoaded
                        ? Container()
                        : Column(
                            children: <Widget>[
                              Material(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "or",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  adhintFunction();
                                },
                                color: Colors.black87,
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text(
                                      "Watch an ad for hint",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  adsolutionFunction();
                                },
                                color: Colors.black87,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Watch an ad for solution",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future showUsedHintDialog(final _path) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          child: _path.contains("svg")
                              ? SvgPicture.asset(_path)
                              : Image.asset(_path),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.black87,
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                "OK, Got it !",
                                style: TextStyle(color: Colors.white),
                              ))),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
  }

  Future showAlertDialog(
      final String _title, final Function _positiveFunction) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Text("$_title",
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _positiveFunction();
                  },
                  icon: Icon(Icons.check),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ));
  }
}
