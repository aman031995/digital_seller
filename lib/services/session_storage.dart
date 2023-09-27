import 'package:universal_html/html.dart';

class SessionStorageHelper{
  static Storage local=window.sessionStorage;

  //to save a data in local storage
  static void savevalue(String key, String value){
    local[key]=value;
  }

//get a data
  static String? getValue(String key){
    return local[key];
  }

//remove data
  static void removeValue(String key){
    local.remove(key);
  }

  static void clearAll(){
    local.clear();
  }

}