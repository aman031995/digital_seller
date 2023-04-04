// import 'dart:convert';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:TychoStream/model/razorpay_credentials.dart';
//
// class RazorpayServices {
//
//   static void createOrder(Razorpay razorPay, var payMoney) async {
//     String username = RazorpayAuth.keyId;
//     String password = RazorpayAuth.keySecret;
//     String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
//
//     Map<String, dynamic> body = {
//       "amount": payMoney * 100,
//       "currency": "INR",
//     };
//     var response = await http.post(Uri.https("api.razorpay.com", "v1/orders"),
//         headers: <String, String>{
//           "Content-Type": "application/json",
//           'authorization': basicAuth,
//         },
//         body: jsonEncode(body));
//
//     if (response.statusCode == 200) {
//       openPaymentGateway(jsonDecode(response.body)['id'], razorPay, payMoney);
//     }
//     print(response.body);
//   }
//
//   static void openPaymentGateway(String orderId, Razorpay razorPay, var payMoney) {
//     var options = {
//       'key': RazorpayAuth.keyId,
//       'amount': payMoney, //in the smallest currency sub-unit.
//       'name': 'TychoStreams',
//       'image': 'https://assets.webiconspng.com/uploads/2017/09/Spider-Man-PNG-Image-23043.png',
//       'order_id': orderId, // Generate order_id using Orders API
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'description': '',
//       'timeout': 60 * 5, // in seconds // 5 minutes
//       'prefill': {
//         'contact': '',
//         'email': '',
//       }
//     };
//     razorPay.open(options);
//   }
// }
