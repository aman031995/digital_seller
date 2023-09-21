import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  VoidCallback? needHelpTap;
  VoidCallback? cancelTap;

  BottomNavButton({Key? key, this.needHelpTap, this.cancelTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(children: [
          Expanded(
            child: SizedBox(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: ResponsiveWidget.isMediumScreen(context)
                              ?2: 20)),
                    ),
                    child: AppBoldFont(context,
                        msg: StringConstant.needHelp, fontSize: 15),
                    onPressed: needHelpTap)),
          ),
          Expanded(
              child: SizedBox(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: ResponsiveWidget.isMediumScreen(context)
                                ?2: 20)),
                      ),
                      child: AppBoldFont(context,
                          color: Theme.of(context).hintColor,
                          msg: StringConstant.cancelOrder,
                          fontSize: 15),
                      onPressed: cancelTap)))
        ]));
  }
}
