import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:TychoStream/view/WebScreen/authentication/verify_otp_screen.dart';


class PinEntryTextFiledView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PinPutView();
  }
}
class PinPutView extends StatefulWidget {
  @override
  PinPutViewState createState() => PinPutViewState();
}

class PinPutViewState extends State<PinPutView> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();
  int _pageIndex = 0;

  final List<Widget> _pinPuts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _pinPuts.addAll([boxedPinPutWithPreFilledSymbol(context)]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.topCenter,
      children: <Widget>[
        AnimatedContainer(
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 200),
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _pageIndex = index);
            },
            children: _pinPuts.map((p) {
              return FractionallySizedBox(
                heightFactor: 1.0,
                child: Center(child: p),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // BoxedPinPutMethod
  Widget boxedPinPutWithPreFilledSymbol(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Pinput(
        showCursor: true,
        length: 4,
        defaultPinTheme: PinTheme(
          width: 65,
          height: 55,
          textStyle: TextStyle(
              fontSize: 20.0, color: Theme.of(context).canvasColor, fontFamily: 'GilroyBold'),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 65,
          height: 55,
          textStyle: TextStyle(
              fontSize: 20.0, color: Theme.of(context).canvasColor, fontFamily: 'GilroyBold'),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).canvasColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
        ).copyDecorationWith(
          border: Border.all(color: Theme.of(context).canvasColor, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        onSubmitted: (String pin) {
          otpValue = pin;
        },
        onChanged: (String pin) {
          otpValue = pin;
        },
        controller: _pinPutController,
        focusNode: _pinPutFocusNode,
      ),
    );
  }
}

