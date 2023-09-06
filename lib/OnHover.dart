import 'package:flutter/material.dart';

class OnHover extends StatefulWidget {
   var hovered ;
   final Widget Function(bool isHovered ) builder;

    OnHover({Key? key, required this.builder,required this.hovered}) : super(key: key);

  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final transform = isHovered ? widget.hovered : Matrix4.identity()..translate(0,-10,0);
    return MouseRegion(
      onEnter: (_)=> onEntered(true),
      onExit: (_)=> onEntered(false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered){
    setState(() {
      this.isHovered = isHovered;
    });
  }

}