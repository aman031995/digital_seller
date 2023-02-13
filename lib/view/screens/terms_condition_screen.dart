import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'no_internet.dart';

class TermsAndConditionsPage extends StatefulWidget {
  String title;
  String description;

  TermsAndConditionsPage({
    Key? key,
    required this.title,
    required this.description
  }) : super(key: key);

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String? checkInternet;

  @override
  void initState() {
    super.initState();
    // getTermsConditionData();
  }

  // // fetch T&C data API call
  // getTermsConditionData() {
  //   AppNetworkManager.fetchTermsAndConditionData(widget.pageType!,
  //           (result, isSuccess) {
  //         if(isSuccess) {
  //           // privacy = ((result as SuccessState).value as ASResponseModal).dataModal;
  //         }
  //         setState(() {});
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // AppNetwork.checkInternet((isSuccess, result) {
    //   setState(() {
    //     checkInternet = result;
    //     // if (privacy == null && checkInternet == "Mobile" || privacy == null && checkInternet == "wifi" ) {
    //     //   getTermsConditionData();
    //     // }
    //   });
    // });
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      appBar: getAppBarWithBackBtn(title: widget.title, isBackBtn: true, context: context),
      body: checkInternet == "Offline"
          ? const NOInternetScreen()
          : SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 10),
          child: AppRegularFont(
            msg: widget.description,
            color: TEXT_COLOR,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
