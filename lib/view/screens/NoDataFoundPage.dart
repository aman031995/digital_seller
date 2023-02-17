// import 'package:flutter/material.dart';
// import 'package:tycho_streams/Utilities/AssetsConstants.dart';
// import 'package:tycho_streams/utilities/AppColor.dart';
// import 'package:tycho_streams/utilities/AppTextButton.dart';
// import 'package:tycho_streams/utilities/SizeConfig.dart';
// import 'package:tycho_streams/utilities/StringConstants.dart';
// import 'package:tycho_streams/utilities/TextHelper.dart';
//
//
// Widget noDataFoundMessage(BuildContext context){
//   return Column(
//     children: [
//       Container(
//         margin: EdgeInsets.only(top: 70),
//         height: SizeConfig.screenHeight * 0.3,
//         width: SizeConfig.screenWidth * 0.90,
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(
//             color: WHITE_COLOR,
//           )
//         ]),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Image.asset(
//                 AssetsConstants.ic_NotFoundLogo,
//                 height: SizeConfig.screenHeight * 0.2,
//                 width: 300,
//               ),
//             ),
//             AppBoldFont(
//                 msg: StringConstant.notFoundMsg,
//                 fontSize: 16,
//                 color: BLACK_COLOR),
//           ],
//         ),
//       ),
//       // Align(
//       //   alignment: Alignment.bottomCenter,
//       //   child: Padding(
//       //       padding: const EdgeInsets.only(top: 40, bottom: 20),
//       //       child: appButton(
//       //           context,
//       //           StringConstant.tryAgain,
//       //           SizeConfig.screenWidth * 0.85,
//       //           60,
//       //           LIGHT_THEME_COLOR,
//       //           WHITE_COLOR,
//       //           20,
//       //           10,
//       //           true,
//       //           onTap: null)),
//       // )
//     ],
//   );
// }
