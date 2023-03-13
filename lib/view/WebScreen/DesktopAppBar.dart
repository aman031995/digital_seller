import 'package:flutter/material.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
class DesktopAppBar extends StatefulWidget {
   DesktopAppBar({Key? key}) : super(key: key);

  @override
  State<DesktopAppBar> createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {
  final ScrollController scrollController = new ScrollController();

  bool loading = false;
  bool isError = false;
  TextEditingController? controller = new TextEditingController();
  void dispose() {
    scrollController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isMediumScreen(context)?

    AppBar(
      backgroundColor: Theme.of(context).primaryColor,
    iconTheme: IconThemeData(color:Colors.black,  size: 28),
    title:  Image.asset(AssetsConstants.icLogo,height: 30),
    )
        :
    Container(
      color: Theme.of(context).primaryColor,
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          Image.asset(AssetsConstants.icLogo,height: 50),
          SizedBox(width: SizeConfig.screenWidth*.02),
          AppButton(context,"Home", onPressed: (){

          }),
          SizedBox(width:  MediaQuery.of(context).size.width*.02),
          AppButton(context, 'Upcoming', onPressed: (){


          }),
          SizedBox(width:  MediaQuery.of(context).size.width*.02),
          AppButton(context, 'Contact Us', onPressed: (){

          }),
          Expanded(
              flex: 1,
              child: SizedBox(width: MediaQuery.of(context).size.width*.40)),
          Container(width: SizeConfig.screenWidth*.03),

          SizedBox(width: SizeConfig.screenWidth*.04),
        ],
      ),
    );
  }
}

