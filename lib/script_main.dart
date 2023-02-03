import 'package:process_run/shell.dart';

void main() async{

  var shell = Shell();
  await shell.run("echo hello");

}