import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String _title;
  final TextEditingController _controller;
  final IconData _icon;
  AuthField(this._title, this._controller, this._icon);

  final Color _textColor = Color(0xff413D7A);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _controller,
        obscureText: _title == "Password" ? true : false,
        decoration: InputDecoration(
          focusColor: _textColor,
          fillColor: _textColor,
          hoverColor: _textColor,
          // border: OutlineInputBorder(),
          hintText: _title,
          hintStyle: TextStyle(color: _textColor, fontSize: 14.0),
          suffixIcon: Icon(_icon, color: _textColor),
        ),
      ),
    );
  }
}
