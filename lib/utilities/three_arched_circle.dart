import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tycho_streams/utilities/DrawArc.dart';

const double _kGapAngle = math.pi / 12;
const double _kMinAngle = math.pi / 36;

class ThreeArchedCircle extends StatefulWidget {
  final double size;
  final Color color;
  const ThreeArchedCircle({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<ThreeArchedCircle> createState() => _ThreeArchedCircleState();
}

class _ThreeArchedCircleState extends State<ThreeArchedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color;
    final double size = widget.size;
    final double ringWidth = size * 0.05;

    final CurvedAnimation _firstRotationInterval = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.linear,
      ),
    );

    final CurvedAnimation _firstArchInterval = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.linear,
      ),
    );

    final CurvedAnimation _secondRotationInterval = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.linear,
      ),
    );

    final CurvedAnimation _secondArchInterval = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        0.9,
        curve: Curves.linear,
      ),
    );

    return Container(
      height: 150,
      width: 320 ,
      color: Colors.transparent,
      child:  Column(
        children: [
          SizedBox(height: 40,),
          Container(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return _animationController.value <= 1 ?
                Transform.rotate(
                  angle: Tween<double>(
                    begin: 0,
                    end: 4 * math.pi / 3,
                  ).animate(_firstRotationInterval).value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle:  math.pi / 2,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: 5 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: 11 * math.pi / 6 ,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -math.pi / 2,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -5 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -11 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                    ],
                  ),
                )
                    : Transform.rotate(
                  angle: Tween<double>(
                    begin: 4 * math.pi / 3,
                    end: (4 * math.pi / 3) + (2 * math.pi / 3),
                  ).animate(_secondRotationInterval).value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle:  math.pi / 2,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: 5 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: 11 * math.pi / 6 ,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -math.pi / 2,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -5 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                      Arc.draw(
                        color: color,
                        size: size,
                        strokeWidth: ringWidth,
                        startAngle: -11 * math.pi / 6,
                        endAngle: Tween<double>(
                          begin:  math.pi / 3 - _kGapAngle,
                          end: _kMinAngle,
                        ).animate(_firstArchInterval).value,
                      ),
                    ],),);
              },
            ),
          ),
          SizedBox(height: 10,),
          Text("  Processing...", style: TextStyle(color: Colors.black),),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}