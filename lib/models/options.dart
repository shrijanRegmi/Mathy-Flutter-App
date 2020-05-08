import 'package:flutter/material.dart';

class Options {
  final String img;
  final String title;
  final Color color;
  Options(this.img, this.title, this.color);
}

List<Options> optionsList = [
    Options("images/brain.svg", "Play Now", Colors.deepOrange),
    Options("images/level.svg", "Levels", Colors.deepPurple),
    Options("images/sound.svg", "Sound", Colors.blueAccent),
    Options("images/share.svg", "Share", Colors.orange),
  ];
