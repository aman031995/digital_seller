import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatefulWidget {
  ShimmerEffect({Key? key}) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,width: SizeConfig.screenWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 50.0,
              height: 50.0,
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey,
                  )
              ),
            );
          }),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  double? width;
  double height;

  ShimmerWidget.rectangular(
      {Key? key, required this.height, this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[400]!,
    highlightColor: Colors.grey[300]!,
    child: Container(
      height: height,
      width: width,
      color: Colors.grey,
    ),
  );
}
