import 'dart:convert';

import 'package:TychoStream/model/data/create_order_model.dart';
import 'package:TychoStream/model/razorpay_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_web/razorpay_web.dart';

class RazorpayServices {

  static void createOrder(Razorpay razorPay, var payMoney) async {
    String username = RazorpayAuth.keyId;
    String password = RazorpayAuth.keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": payMoney * 100,
      "currency": "INR",
    };
    var response = await http.post(Uri.https("api.razorpay.com", "v1/orders"),
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': basicAuth,
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      // openPaymentGateway(jsonDecode(response.body)['id'], razorPay, payMoney);
    }
    print(response.body);
  }

  static void openPaymentGateway(CreateOrderModel? createOrderModel, Razorpay razorPay) {
    var options = {
      'key': createOrderModel?.key,
      'amount': createOrderModel?.total,
      'receipt': createOrderModel?.receipt,
      'name': createOrderModel?.name ?? '',
      'image': createOrderModel?.image ?? '',
      'order_id': createOrderModel?.paymentOrderId,
      'retry': {
        'enabled': createOrderModel?.retryEnabled ?? false,
        'max_count': createOrderModel?.retryMaxCount ?? 1
      },
      'send_sms_hash': createOrderModel?.sendSmsHash ?? false,
      'description': createOrderModel?.description ?? '',
      'timeout': createOrderModel?.timeout ?? 60 * 5,
      'prefill': {
        'contact': createOrderModel?.contact ?? '',
        'email': createOrderModel?.email ?? '',
      }
    };
    razorPay.open(options);
  }
}
