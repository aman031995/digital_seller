import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final _pageController = PageController();
  int _pageIndex = 0;
  final defaultPinTheme = PinTheme(
    width: 65,
    height: 55,
    textStyle: const TextStyle(
        fontSize: 20.0, color: BLACK_COLOR, fontFamily: 'GilroyBold'),
    decoration: BoxDecoration(
      border: Border.all(color: APP_TEXT_LIGHT_COLOR, width: 2),
      borderRadius: BorderRadius.circular(30),
    ),
  );

  final List<Widget> _pinPuts = [];

  @override
  void initState() {
    _pinPuts.addAll([boxedPinPutWithPreFilledSymbol(context)]);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        AnimatedContainer(
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

  Widget boxedPinPutWithPreFilledSymbol(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: WHITE_COLOR,
      border: Border.all(color: TEXTFIELD_BORDER_COLOR, width: 2),
      borderRadius: BorderRadius.circular(30.0),
    );
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Pinput(
        showCursor: true,
        length: 4,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(color: GREEN_COLOR, width: 2),
          borderRadius: BorderRadius.circular(30),
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
