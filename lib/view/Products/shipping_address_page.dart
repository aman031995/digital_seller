import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/model/data/checkout_data_model.dart';
import 'package:TychoStream/model/data/city_state_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  bool isAlreadyAdded;
  AddressListModel? address;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? firstAddress;
  String? secondAddress;
  String? state;
  String? cityName;
  String? pinCode;
  String? addressId;

  ShippingAddressPage({Key? key, this.address, required this.isAlreadyAdded,this.addressId,this.firstName,this.lastName,this.mobileNumber,this.pinCode,this.state,this.cityName,this.secondAddress,this.firstAddress,this.email})
      : super(key: key);

  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  TextEditingController firstNameController =  TextEditingController();
  TextEditingController lastNameController =  TextEditingController();
  TextEditingController mobileNumberController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController addressFirstController =  TextEditingController();
  TextEditingController addressSecondController =  TextEditingController();
  TextEditingController stateController =  TextEditingController();
  TextEditingController cityController =  TextEditingController();
  TextEditingController pinCodeController =  TextEditingController();
  final validation = ValidationBloc();
  String? checkInternet;
  CartViewModel cartViewData = CartViewModel();
  CityStateModel _cityStateModel=CityStateModel();
  @override
  void initState() {

    firstNameController.text = widget.firstName ?? '';
    lastNameController.text = widget.lastName ?? '';
    mobileNumberController.text = widget.mobileNumber ?? '';
    emailController.text = widget.email ?? '';
    addressFirstController.text = widget.firstAddress ?? '';
    addressSecondController.text = widget.secondAddress ?? '';
    stateController.text = widget.state ?? '';
    cityController.text = widget.cityName ?? '';
    pinCodeController.text = widget.pinCode ?? '';
    validateAddressDetails();
    super.initState();
  }

  validateAddressDetails() {
    validation.sinkFirstName.add(widget.firstName ?? '');
    validation.sinkLastName.add(widget.lastName ?? '');
    validation.sinkPhoneNo.add(widget.mobileNumber ?? '');
    validation.sinkEmail.add(widget.email ?? '');
    validation.sinkAddress.add(widget.firstAddress ?? '');
    validation.sinkAddressOne.add(widget.secondAddress ?? '');
    validation.sinkPincode.add(widget.pinCode ?? '');
    validation.sinkCityName.add(widget.cityName ?? '');
    validation.sinkState.add(widget.state ?? '');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return AlertDialog(
        elevation: 8,
        buttonPadding:EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2)),
        backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
        content:  Container(
          height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight/1.2:SizeConfig.screenHeight/1.6,
          width:ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth: SizeConfig.screenWidth*0.25,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                AppBoldFont(context,
                    msg: "ContactDetails",
                    fontSize: 16.0),
                Container(
                  padding: EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      addAddressTextField(firstNameController, StringConstant.firstName, TextInputType.text, validation.sinkFirstName, 50, validation.firstName),
                      SizedBox(
                        height: 15.0,
                      ),
                      addAddressTextField(lastNameController, StringConstant.lastName, TextInputType.text, validation.sinkLastName, 50, validation.lastName),
                      SizedBox(
                        height: 15.0,
                      ),
                      addAddressTextField(mobileNumberController, StringConstant.mobileNo, TextInputType.phone, validation.sinkPhoneNo, 10, validation.phoneNo),
                      SizedBox(
                        height: 15.0,
                      ),
                      addAddressTextField(emailController, StringConstant.email, TextInputType.emailAddress, validation.sinkEmail, 50, validation.email),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                AppBoldFont(context,
                    msg: StringConstant.address,
                    fontSize: 15.0),
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Column(children: [
                      addAddressTextField(addressFirstController, StringConstant.address1, TextInputType.streetAddress, validation.sinkAddress, 50, validation.address),
                      SizedBox(
                        height: 15.0,
                      ),
                      addAddressTextField(addressSecondController, StringConstant.address2, TextInputType.streetAddress, validation.sinkAddressOne, 50, validation.addressOne),
                      SizedBox(
                        height: 15.0,
                      ),
                      StreamBuilder(
                          stream: validation.pincode,
                          builder: (context, snapshot) {
                            return AppTextField(
                                maxLine: null,
                                prefixText: '',
                                controller: pinCodeController,
                                labelText: StringConstant.pincode,
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                isColor: false,
                                isTick: false,
                                maxLength: 6,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                onChanged: (m) {
                                  validation.sinkPincode.add(m);
                                  if(m.length==6){
                                    cityController.clear();
                                    stateController.clear();
                                    cartViewData.getCityState(context, m, (result, isSuccess) {
                                      if(isSuccess){
                                        setState(() {
                                          _cityStateModel = ((result as SuccessState).value as ASResponseModal).dataModal;
                                          if(_cityStateModel.state==null || _cityStateModel.city==null ){
                                            ToastMessage.message("Pincode Not Found",context);
                                          }
                                          else{
                                            cityController.text = _cityStateModel.city ?? "";
                                            stateController.text = _cityStateModel.state ?? "";
                                            validation.sinkState.add(stateController.text);
                                            validation.sinkCityName.add(cityController.text);
                                          }
                                        });
                                      }
                                      else{

                                      }

                                    });

                                  }},
                                keyBoardType: TextInputType.number,
                               );
                          }),
                      SizedBox(height: 15.0),
                      StreamBuilder(
                          stream: validation.cityName,
                          builder: (context, snapshot) {
                            return AppTextField(
                                maxLine: null,
                                prefixText: '',isRead: true,
                                controller: cityController,
                                labelText: StringConstant.cityName,
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                isColor: false,
                                isTick: false,
                                maxLength: 20,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                keyBoardType: TextInputType.streetAddress,
                            );
                          }),
                      SizedBox(height: 15.0),
                      StreamBuilder(
                          stream: validation.state,
                          builder: (context, snapshot) {
                            return AppTextField(
                                maxLine: null,isRead: true,
                                prefixText: '',
                                controller: stateController,
                                labelText: StringConstant.state,
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                isColor: false,
                                isTick: false,
                                maxLength: 20,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                keyBoardType: TextInputType.streetAddress);
                          }),
                      SizedBox(height: 15.0,),
                      StreamBuilder(
                          stream: validation.validateAddAddress,
                          builder: (context, snapshot) {
                            return appButton(
                                context,
                                StringConstant.Save,
                                SizeConfig.screenWidth * 0.7,
                                60.0,
                                LIGHT_THEME_COLOR,
                                WHITE_COLOR,
                                18,
                                10,
                                snapshot.data != true ? false : true,
                                onTap: () {
                              snapshot.data != true
                                  ? ToastMessage.message(
                                      StringConstant.fillOut,context)
                                  : widget.isAlreadyAdded == true
                                      ? cartViewData
                                          .updateExistingAddress(
                                              context,
                                              widget.addressId ?? '',
                                              firstNameController.text,
                                              lastNameController.text,
                                              emailController.text,
                                              mobileNumberController
                                                  .text,
                                              addressFirstController.text,
                                              addressSecondController.text,
                                              pinCodeController.text,
                                              cityController.text,
                                              stateController.text,
                                             ''

                              )
                                      : addNewAddress();
                            });
                          }),
                      SizedBox(height: 10.0),
                    ])),
              ],
            ),
          ),
        ));
  }

  addNewAddress() {
    var pinCode = int.parse(pinCodeController.text);
    cartViewData.addNewAddress(
        context,
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        mobileNumberController.text,
        addressFirstController.text,
        addressSecondController.text,
        pinCode,
        cityController.text,
        stateController.text
       );
  }

  Widget addAddressTextField(TextEditingController addAddressController, String msg, var keyBoardType, var validationType, int maximumLength, var streamValidationType){
    return StreamBuilder(
        stream: streamValidationType,
        builder: (context, snapshot) {
          return AppTextField(
              maxLine: null,
              prefixText: '',
              controller: addAddressController,
              labelText: msg,
              isShowCountryCode: true,
              isShowPassword: false,
              secureText: false,
              isColor: false,
              isTick: false,
              maxLength: maximumLength,
              errorText: snapshot.hasError
                  ? snapshot.error.toString()
                  : null,
              onChanged: (m) {
                validationType.add(m);
                setState(() {});
              },
              keyBoardType: keyBoardType,
              onSubmitted: (m) {});
        });
  }
}
