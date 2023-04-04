import 'package:logger/logger.dart';

class LogsMessage{
  static logMessage({required dynamic message, required Level level}){
    final logger = Logger(
        printer: PrettyPrinter(
          methodCount: 5,
          errorMethodCount: 5,
          colors: true,
          printEmojis: true,
        )
    );
    logger.log(level, message);
  }
}