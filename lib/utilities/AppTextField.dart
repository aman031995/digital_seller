import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppColor.dart';
import 'AssetsConstants.dart';
import 'TextStyling.dart';

bool _secureText = true;
String? countryDialCode;
String? countryCodeValue;

class AppTextField extends StatefulWidget {
  TextEditingController? controller;
  bool? isShowPassword = false;
  String? labelText;
  bool? secureText;
  bool? isShowCountryCode;
  String? prefixText;
  ValueChanged<String>? onSubmitted;
  bool? isError;
  TextInputType? keyBoardType;
  int? maxLength;
  double? height;
  bool? isEnable;
  bool? isColor;
  ValueChanged<String>? onChanged;
  bool? isTick;
  int? maxLine;
  String? errorText;
  TextCapitalization? textCapitalization;

  AppTextField(
      {Key? key,
      this.isShowCountryCode,
      required this.controller,
      this.labelText,
      this.secureText,
      this.prefixText,
      this.onSubmitted,
      this.isError,
      this.keyBoardType,
      this.maxLength,
      this.isShowPassword,
      this.height,
      this.isEnable,
      this.isColor,
      this.onChanged,
      this.maxLine,
      required this.isTick,
      this.errorText,
      this.textCapitalization})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: widget.height,
      child: Theme(
        data: new ThemeData(
          primaryColor: THEME_COLOR,
          disabledColor: THEME_COLOR,
          primaryColorDark: THEME_COLOR,
        ),
        child: new TextField(
            maxLines: widget.maxLine,
            onChanged: widget.onChanged,
            enabled: widget.isEnable,
            textCapitalization: widget.textCapitalization == null
                ? widget.textCapitalization = TextCapitalization.none
                : widget.textCapitalization!,
            cursorColor: TEXT_COLOR,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            controller: widget.controller,
            style: TextStyle(color: TEXT_COLOR, fontSize: 18),
            onSubmitted: widget.onSubmitted,
            decoration: new InputDecoration(
              errorText: widget.errorText,
              errorStyle: CustomTextStyle.textFormFieldGILROYMedium
                  .copyWith(color: RED_COLOR, fontSize: 12),
              errorMaxLines: 3,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: RED_COLOR, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: RED_COLOR, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: TEXTFIELD_BORDER_COLOR, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: TEXTFIELD_BORDER_COLOR, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: TEXTFIELD_BORDER_COLOR, width: 2),
              ),
              isDense: true,
              //  <- you can it to 0.0 for no space
              suffixIcon: widget.isShowPassword == true
                  ? IconButton(
                      icon: Image.asset(
                          _secureText == true
                              ? AssetsConstants.icEyeFill
                              : AssetsConstants.ic_passwordHide,
                          width: 25,
                          height: 25),
                      onPressed: () {
                        setState(() {
                          _secureText = !_secureText;
                        });
                      },
                    )
                  : IconButton(
                      icon: widget.isTick == false ? Container() : Container(),
                      onPressed: () {},
                    ),
              labelText: widget.labelText,
              contentPadding: EdgeInsets.only(left: 25.0, top: 15),
              labelStyle: CustomTextStyle.textFormFieldGILROYMedium.copyWith(
                  color: widget.isColor == true
                      ? TEXT_COLOR
                      : TEXTFIELD_BORDER_COLOR,
                  fontSize: 17),
              prefixText: widget.prefixText,
              suffixStyle: CustomTextStyle.textFormFieldGILROYMedium
                  .copyWith(color: TEXT_COLOR, fontSize: 17),
              prefixStyle: TextStyle(color: TEXT_COLOR, fontSize: 20),
            ),
            keyboardType: widget.keyBoardType,
            obscureText: widget.isShowPassword == true
                ? _secureText
                : widget.secureText!),
      ),
    );
  }
}
