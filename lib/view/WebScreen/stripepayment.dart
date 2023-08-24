@JS()
library stripe;

import 'package:js/js.dart';


// void redirectToCheckout(BuildContext _){
//   //Stripe.publishableKey = "pk_live_51NXhtjSJK48GkIWFY3NeBL1mw7CATawc8xbjlwBi5wrTr61UbS9sHQWjnEr5kb9tSytKgZGWsbMkYish4xs2ILIC00OZVlrRNY";
//
//   final stripe =Stripe("pk_live_51NXhtjSJK48GkIWFY3NeBL1mw7CATawc8xbjlwBi5wrTr61UbS9sHQWjnEr5kb9tSytKgZGWsbMkYish4xs2ILIC00OZVlrRNY");
// stripe.redirectToCheckout(CheckoutOptions(
//   lineItems: [
//     LineItem(
//       price:'price_1HFw3QAQHy2zYPZft7bbrtWZ',
//       quantity:1
//     )
//
//   ],
//   mode: 'payment',
//   successUrl: 'http://localhost:8088/#/success',
//
// ));
//
// }

@JS()
class Stripe{
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions{
  external List<LineItem> get lineItems;
  external String get mode;
  external String get successUrl;
  external String get cancelUrl;
  external String get sessionId;
  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String  successUrl,
    String  cancelUrl,
     String  sessionId,
});

}
@JS()
@anonymous
class LineItem{
  external String get price;
  external int get quantity;
external factory LineItem({String price,int quantity});

}