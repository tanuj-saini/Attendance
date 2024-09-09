class AppException implements Exception {
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class InternetException extends AppException {
  InternetException([String? message]) : super(message, 'No Internet');
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([String? message])
      : super(message, 'Request Time Out');
}

class ServerException extends AppException {
  ServerException([String? message]) : super(message, 'Internal Server Error');
}

class InvalidUrlException extends AppException {
  InvalidUrlException([String? message]) : super(message, 'Invalid URL Error');
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Fetch Communication Error');
}

class EmailAlreadyExistsException extends AppException {
  EmailAlreadyExistsException([String? message]) : super(message, '');
}
