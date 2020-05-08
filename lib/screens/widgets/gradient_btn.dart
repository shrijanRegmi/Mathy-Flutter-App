import 'package:flutter/material.dart';

class MyGradientBtn extends StatelessWidget {
  final String title;
  final Function function;
  final IconData icon;
  final List<Color> colors;
  MyGradientBtn({
    this.title,
    this.icon,
    this.colors,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10.0,
                offset: Offset(0, 0),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: icon != null && title != null
              ? Row(
                  children: <Widget>[
                    Icon(icon, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("$title", style: TextStyle(color: Colors.white))
                  ],
                )
              : title != null
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                    child: Text("$title", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  )
                  : Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
