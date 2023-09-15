import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'regex.dart';

class ValidationBloc {
  final _phoneNumber = BehaviorSubject<String>.seeded('');
  final _password = BehaviorSubject<String>.seeded('');
  final _forgotPassword = BehaviorSubject<String>.seeded("");
  final _confirmPassword = BehaviorSubject<String>.seeded("");
  final _fullName = BehaviorSubject<String>.seeded('');
  final _firstName = BehaviorSubject<String>.seeded('');
  final _lastName = BehaviorSubject<String>.seeded('');
  final _cityName = BehaviorSubject<String>.seeded('');
  final _email = BehaviorSubject<String>.seeded('');
  final _emailAndPhone = BehaviorSubject<String>.seeded('');
  final _address = BehaviorSubject<String>.seeded('');
  final _addressOne = BehaviorSubject<String>.seeded('');
  final _landmark = BehaviorSubject<String>.seeded('');
  final _pincode = BehaviorSubject<String>.seeded('');
  final _state = BehaviorSubject<String>.seeded('');
  final _country = BehaviorSubject<String>.seeded('');
  final _oldPassword = BehaviorSubject<String>.seeded('');

  Stream<String> get fullName => _fullName.stream.transform(validateFullName);
  Sink<String> get sinkName => _fullName.sink;
  Stream<String> get firstName => _firstName.stream.transform(validateFirstName);
  Sink<String> get sinkFirstName => _firstName.sink;

  Stream<String> get lastName => _lastName.stream.transform(validateLastName);
  Sink<String> get sinkLastName => _lastName.sink;

  Stream<String> get phoneNo => _phoneNumber.stream.transform(validatePhoneNo);
  Sink<String> get sinkPhoneNo => _phoneNumber.sink;

  Stream<String> get email => _email.stream.transform(validateEmail);
  Sink<String> get sinkEmail => _email.sink;

  Stream<String> get address => _address.stream.transform(validateEntry);
  Sink<String> get sinkAddress => _address.sink;

  Stream<String> get addressOne => _addressOne.stream.transform(validateEntry);
  Sink<String> get sinkAddressOne => _addressOne.sink;

  Stream<String> get landMark => _landmark.stream.transform(validateEntry);
  Sink<String> get sinkLandmark => _landmark.sink;

  Stream<String> get pincode => _pincode.stream.transform(validatePincode);
  Sink<String> get sinkPincode => _pincode.sink;

  Stream<String> get state => _state.stream.transform(validateState);
  Sink<String> get sinkState => _state.sink;

  Stream<String> get cityName => _cityName.stream.transform(ValidateCity);
  Sink<String> get sinkCityName => _cityName.sink;

  Stream<String> get country => _country.stream.transform(validateCountry);
  Sink<String> get sinkCountry => _country.sink;

  Stream<String> get forgotPassword => _forgotPassword.stream.transform(validatePhoneNo);
  Sink<String> get sinkForgot => _forgotPassword.sink;

  Stream<String> get password => _password.stream.transform(validatePassword);
  Sink<String> get sinkPassword => _password.sink;

  Stream<String> get oldPassword => _oldPassword.stream.transform(validatePassword);
  Sink<String> get sinkoldPassword => _oldPassword.sink;

  Stream<String> get confirmPassword => _confirmPassword.stream.transform(validatePassword);
  Sink<String> get sinkConfirmPassword => _confirmPassword.sink;

  Stream<String> get emailAndMobile => _emailAndPhone.stream.transform(validateEmailAndPhone);
  Sink<String> get sinkEmailAndPhone => _emailAndPhone.sink;

  Stream<bool> get checkEmailValidate => Rx.combineLatest({email}, (values) => true);
  Stream<bool> get checkEmailAndPhoneValidate => Rx.combineLatest({emailAndMobile}, (values) => true);
  Stream<bool> get checkPhoneValidate => Rx.combineLatest({phoneNo}, (values) => true);
  Stream<bool> get checkUserPhoneLogin => Rx.combineLatest2(phoneNo, password, (a, b) => true);
  Stream<bool> get checkUserEmailLogin => Rx.combineLatest2(email, password, (a, b) => true);
  Stream<bool> get checkResetPasswordValidate => Rx.combineLatest2(password, confirmPassword, (a, b) => true);
  Stream<bool> get registerUser => Rx.combineLatest4(firstName, email, phoneNo, password, (a, b, c, d) => true);
  Stream<bool> get registerWithoutNumberUser => Rx.combineLatest3(firstName, email, password, (a, b, c) => true);
  Stream<bool> get checkUserInfoValidate => Rx.combineLatest2(email, phoneNo, (a, b) => true);
  Stream<bool> get submitValid => Rx.combineLatest2(emailAndMobile, password, (e, p) => true);
  Stream<bool> get validateUserEditProfile => Rx.combineLatest2(firstName, phoneNo, (a, b) => true);
  Stream<bool> get validateContactUs => Rx.combineLatest3(firstName, email, address, (a, b, c) => true);
  Stream<bool> get validateAddAddress => CombineLatestStream([firstName, lastName, phoneNo, email, address, addressOne, landMark, pincode, cityName, state], (list) => true);



  final validateFullName =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      Regex.isFullName(value)
          ? value.length >= 2
          ? sink.add(value)
          : sink.addError('Full Name should be atleast 2 character')
          : sink.addError('Full Name must be a-z and A-Z');
    }
  });

  final validateFirstName =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      Regex.isFullName(value)
          ? value.length >= 2
          ? sink.add(value)
          : sink.addError('Name should be atleast 2 character')
          : sink.addError('Name must be a-z and A-Z');
    }
  });

  final validateLastName =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      Regex.isFullName(value)
          ? value.length >= 2
          ? sink.add(value)
          : sink.addError('Last Name should be atleast 2 character')
          : sink.addError('Last Name must be a-z and A-Z');
    }
  });

  final validatePhoneNo =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      isPhone(value)
          ? value.length == 10
          ? sink.add(value)
          : sink.addError('Mobile Number must be 10 digits')
          : sink.addError('Mobile Number must be digits');
    }
  });

  static bool isPhone(String phoneNo) {
    String value = r'(^[0-9]*$)';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(phoneNo);
  }

  final validateEntry = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if(value.length > 0){
      value.length > 2 ? sink.add(value) : sink.addError("Please enter Detail Address");
    }
  });

  final ValidateCity = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if(value.length > 0){
      value.length > 2 ? sink.add(value) : sink.addError("Please Enter City");
    }
  });

  final validateState = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if(value.length > 0){
      value.length > 1 ? sink.add(value) : sink.addError("Please Enter State");
    }
  });

  final validatePincode =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if(value.length > 0){
      value.length > 5 ? sink.add(value) : sink.addError("Please Enter PinCode");
    }
  });
  final validateCountry =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if(value.length > 0){
      value.length > 1 ? sink.add(value) : sink.addError("Please Enter Country ");
    }
  });

  final validateDescription =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      Regex.isDescription(value)
          ? value.length >= 10
          ? sink.add(value)
          : sink.addError('Description must be in 10 characters')
          : sink.addError('Description must be in 10 characters');
    }
  });

  final validateTitle =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      value.length >= 2
          ? sink.add(value)
          : sink.addError('Title should be atleast 2 character');
    }
  });

  final validateCompanyName =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      Regex.isFullName(value)
          ? value.length >= 2
          ? sink.add(value)
          : sink.addError('Company Name should be atleast 2 character')
          : sink.addError('Company Name must be a-z and A-Z');
    }
  });

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 0) {
      Regex.isEmail(value)
          ? sink.add(value)
          : sink.addError("Please enter a valid email address");
    }
  });

  final validateEmailAndPhone =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 0) {
      if (!Regex.isEmail(value) && !Regex.isPhone(value)) {
        return sink.addError("Please enter a valid email or phone number.");
      } else if (value.length < 10) {
        return sink.addError("Please enter a valid email or phone number.");
      } else {
        return sink.add(value);
      }
    }
  });

  final validatePassword =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length >= 8 && value.length != 0) {
      Regex.isPassword(value)
          ? sink.add(value)
          : sink.addError('Password should be combination of one uppercase, one lower case, one special char & one numeric, min 8 digit.');
    } else if (value.length < 8 && value.length > 0) {
      sink.addError('Password should be combination of one uppercase, one lower case, one special char & one numeric, min 8 digit.');
    }
  });

  void closeStream() {
    _phoneNumber.close();
    _password.close();
    _forgotPassword.close();
    _firstName.close();
    _lastName.close();
    _confirmPassword.close();
    _cityName.close();
    _fullName.close();
    _email.close();
    _address.close();
    _addressOne.close();
    _pincode.close();
    _state.close();
    _country.close();
    _emailAndPhone.close();
    _oldPassword.close();
  }
}