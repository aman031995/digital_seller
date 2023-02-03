import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextStyling.dart';
import 'package:tycho_streams/view/screens/terms_condition_screen.dart';

Widget termsAndCondition(BuildContext context,
    double _width,) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: _width * 0.84,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: StringConstant.agreeTermsFinancier,
                      style: TextStyle(color: GREY_COLOR, fontSize: 16),
                      children: <TextSpan>[
                        termsAndConditionText(
                            StringConstant.termsAndCondition, 16,
                            LIGHT_GREEN_COLOR,
                                () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) =>
                                  TermsAndConditionsPage(
                                    titleAppBar: StringConstant
                                        .termsAndCondition,
                                    pageType: StringConstant.terms,
                                  )));
                            }),
                        termsAndConditionText('and ', 16, GREY_COLOR, () {}),
                        termsAndConditionText(
                            StringConstant.privacy, 16, LIGHT_GREEN_COLOR, () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) =>
                              TermsAndConditionsPage(
                                titleAppBar: StringConstant
                                    .privacyPolicy,
                                pageType: StringConstant.privacyOfPolicy,
                              )));
                        })
                      ],
                    ),
                  ),
                ),
              ]))
    ],
  );
}

TextSpan termsAndConditionText(String text, double fontSize, dynamic color,
    GestureTapCallback? onTap) {
  return TextSpan(
    text: text,
    recognizer: TapGestureRecognizer()
      ..onTap = onTap,
    style: CustomTextStyle.textFormFieldGILROYMedium
        .copyWith(color: color, fontSize: fontSize),
  );
}
