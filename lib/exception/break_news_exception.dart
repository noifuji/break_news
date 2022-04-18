import 'exception_messages.dart';

class BreakNewsException implements Exception {
  final ExceptionCode _code;
  String? message;

  BreakNewsException(this._code) {
    message = messages[_code];
  }
}

