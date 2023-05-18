import 'package:flutter/material.dart';

List<Widget> buildIndicator(List<String>? imagePath,int currentIndex,BuildContext context) {
  List<Widget> indicators = [];
  for (int i = 0; i < imagePath!.length; i++) {
    if (currentIndex == i) {
      indicators.add(_indicator(true,context));
    } else {
      indicators.add(_indicator(false,context));
    }
  }
  return indicators;
}

Widget _indicator(bool isActive,BuildContext context) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    height: 10,
    width: isActive ? 15 : 10,
    margin: EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5)),
  );
}