import 'package:mathy/screens/home/play_screen.dart';
import 'package:mathy/screens/widgets/gradient_btn.dart';
import 'package:flutter/material.dart';

class CorrectScreen extends StatelessWidget {
  final int level;
  final bool gameCompleted;
  CorrectScreen({this.level, this.gameCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                gameCompleted == null
                    ? Icons.check_circle_outline
                    : Icons.tag_faces,
                color: Colors.white,
                size: 150.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                gameCompleted == null
                    ? "Correct !"
                    : "Congratulations ! You have completed all the levels of this game.",
                style: TextStyle(
                    fontSize: gameCompleted == null ? 32.0 : 20.0,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              MyGradientBtn(
                title: gameCompleted == null ? "Next" : "Go Home",
                colors: gameCompleted == null
                    ? [Colors.blueAccent, Colors.blue[800]]
                    : [Colors.deepPurple, Colors.purple],
                function: () {
                  Navigator.pop(context);

                  if (gameCompleted != null) {
                    // Navigator.pop(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PlayScreenWrapper(
                                  level: level,
                                )));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
