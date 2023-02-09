class Regex {
  static bool isFullName(String name) {
    String value = r'^([^-\s\d][a-zA-Z ]*$)';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(name);
  }

  static bool isPhone(String phoneNo) {
    String value = r'(^[0-9]*$)';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(phoneNo);
  }

  static bool isDescription(String desc) {
    String value = r'^(.|\s)[^-\s\d]*[a-zA-Z]+(.|\s)*$';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(desc);
  }

  static bool isEmail(String email) {
    String value =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(email);
  }

  static bool isPassword(String password) {
    String value = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(password);
  }

  static String? validatePinNumber(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "PIN  is Required";
    } else if (value.length != 4) {
      return "PIN must 4 digits";
    } else if (!regExp.hasMatch(value)) {
      return "PIN must be digits";
    }
    return '';
  }
}
