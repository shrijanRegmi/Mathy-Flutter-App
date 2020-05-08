import 'package:mathy/models/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionsItem extends StatelessWidget {
  final Options _list;
  OptionsItem(this._list);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          width: 150.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: _list.color.withOpacity(0.5),
                blurRadius: 10.0,
                offset: Offset(5, 5)),
          ], borderRadius: BorderRadius.circular(20.0), color: _list.color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 70.0,
                child: SvgPicture.asset(_list.img)),
              SizedBox(
                height: 10.0,
              ),
              Text(_list.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0))
            ],
          )),
    );
  }
}
