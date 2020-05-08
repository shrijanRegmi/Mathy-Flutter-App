import 'package:mathy/models/function/changeIndex.dart';
import 'package:mathy/models/questions.dart';
import 'package:mathy/screens/home/play_screen.dart';
import 'package:mathy/screens/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelScreen extends StatefulWidget {
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final Color _textColor = Color(0xff413D7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _textColor,
      body: SafeArea(
        child: Container(
          color: Color(0xfff3f3f3),
          child: Column(
            children: <Widget>[
              MyAppBar("Levels"),
              SizedBox(
                height: 10.0,
              ),
              _levelList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelList() {
    return Expanded(
        child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: gameQuestion.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (_, index) {
              return _levelItem(index + 1);
            }));
  }

  Widget _levelItem(int _level) {
    final _completedLevels = Provider.of<ChangeIndex>(context);

    return GestureDetector(
      onTap: () {
        if (_completedLevels.completedQuestionList.contains(_level - 1)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PlayScreenWrapper(
                        level: _level,
                      )));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: _level == _completedLevels.completedQuestionList.length
                    ? Colors.blueAccent
                    : Colors.black87,
              ),
              child: Center(
                child: Text("$_level",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            _completedLevels.completedQuestionList.contains(_level)
                ? Positioned(
                    top: 2.0,
                    right: 2.0,
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
