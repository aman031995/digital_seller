import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextStyling.dart';
import 'package:tycho_streams/view/screens/terms_condition_screen.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';

class TermsConditionAgreement extends StatefulWidget {
  double? width;

  TermsConditionAgreement({Key? key, this.width}) : super(key: key);

  @override
  State<TermsConditionAgreement> createState() =>
      _TermsConditionAgreementState();
}

class _TermsConditionAgreementState extends State<TermsConditionAgreement> {
  final ProfileViewModel profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    profileViewModel.getTermsPrivacy(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Container(
                      width: widget.width! * 0.84,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: StringConstant.agreeTermsFinancier,
                          style: TextStyle(color: GREY_COLOR, fontSize: 16),
                          children: <TextSpan>[
                            termsAndConditionText(
                                StringConstant.termsAndCondition,
                                16,
                                THEME_COLOR, () {
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (_) => TermsAndConditionsPage(
                                    title: '${viewmodel.termsPrivacyModel?[1].pageTitle}',
                                    description: '${viewmodel.termsPrivacyModel?[1].pageDescription}',
                                  )));
                            }),
                            termsAndConditionText(
                                'and ', 16, GREY_COLOR, () {}),
                            termsAndConditionText(
                                StringConstant.privacy, 16, THEME_COLOR,
                                () {
                                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                      builder: (_) => TermsAndConditionsPage(
                                        title: '${viewmodel.termsPrivacyModel?[0].pageTitle}',
                                        description: '${viewmodel.termsPrivacyModel?[0].pageDescription}',
                                      )));
                            })
                          ],
                        ),
                      ),
                    ),
                  ]))
            ],
          );
        }));
  }
}

Widget termsAndCondition(
  BuildContext context,
  double _width,
) {
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
                        StringConstant.termsAndCondition, 16, TEXT_BLACK_COLOR,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TermsAndConditionsPage(
                                    title: StringConstant.termsAndCondition,
                                    description: StringConstant.terms,
                                  )));
                    }),
                    termsAndConditionText('and ', 16, GREY_COLOR, () {}),
                    termsAndConditionText(
                        StringConstant.privacy, 16, TEXT_BLACK_COLOR, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TermsAndConditionsPage(
                                    title: StringConstant.privacyPolicy,
                                    description: StringConstant.privacyOfPolicy,
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

TextSpan termsAndConditionText(
    String text, double fontSize, dynamic color, GestureTapCallback? onTap) {
  return TextSpan(
    text: text,
    recognizer: TapGestureRecognizer()..onTap = onTap,
    style: CustomTextStyle.textFormFieldInterMedium
        .copyWith(color: color, fontSize: fontSize),
  );
}
