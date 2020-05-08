import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final _title;
  MyAppBar(this._title);

  final Color _textColor = Color(0xff413D7A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "$_title",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16.0, color: _textColor),
          ),
        ],
      ),
    );
  }
}
