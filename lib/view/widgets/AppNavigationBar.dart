// import 'package:flutter/material.dart';
// import 'package:TychoStream/utilities/AppColor.dart';
// import 'package:TychoStream/utilities/AssetsConstants.dart';
// import 'package:TychoStream/utilities/TextHelper.dart';
//
// AppBar getAppBarWithBackBtn(
//     {String? title,
//       bool? isBackBtn,
//       String? itemCount,
//       bool? isShopping,
//       bool? isFavourite,
//       VoidCallback? onFavPressed,
//       VoidCallback? onCartPressed,
//       required VoidCallback onBackPressed,
//       required BuildContext context}) {
//   return AppBar(
//     elevation: 0,
//     leading: isBackBtn == true
//         ? GestureDetector(
//       onTap: onBackPressed,
//       child: Container(
//         width: 500,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(width: 1),
//             Expanded(
//               child: Container(
//                   height: 15,
//                   width: 15,
//                   child: Image.asset(AssetsConstants.icBackArrow,
//                       color: Theme.of(context).canvasColor, width: 15, height: 15)),
//             ),
//           ],
//         ),
//       ),
//     )
//         : Container(),
//     actions: [
//       Row(
//         children: [
//           isFavourite == true
//               ? GestureDetector(
//               onTap: onFavPressed,
//               child: Icon(Icons.favorite_border, color: Theme.of(context).canvasColor, size: 25))
//               : SizedBox(),
//           SizedBox(width: 8),
//           isShopping == true
//               ? Stack(
//             children: [
//               GestureDetector(
//                   onTap: onCartPressed,
//                   child: Icon(Icons.shopping_cart,
//                       color: Theme.of(context).canvasColor, size: 30)),
//               itemCount != '0'
//                   ? Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     padding: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.red,
//                     ),
//                     child: Text(
//                       itemCount ?? '',
//                       style: TextStyle(color: WHITE_COLOR),
//                     ),
//                   ))
//                   : SizedBox()
//             ],
//           )
//               : SizedBox(),
//           SizedBox(width: 15)
//         ],
//       )
//     ],
//     centerTitle: true,
//     title: AppBoldFont(
//         context,msg: title ?? '',
//         color: Theme.of(context).canvasColor,
//         fontSize: 17,
//         textAlign: TextAlign.start),
//     backgroundColor: Theme.of(context).cardColor,
//   );
// }
