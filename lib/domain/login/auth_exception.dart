class AuthException implements Exception {}

class InvalidEmailAndPasswordCombination extends AuthException {
  @override
  String toString() {
    return 'Invalid email and password combination';
  }
}

class NotAdminException extends AuthException {
  @override
  String toString() {
    return 'Only Hillz admin can sign in';
  }
}

class EmailNotVerified extends AuthException {}

class EmailAlreadyExists extends AuthException {}

class IncorrectCodeException extends AuthException {
  @override
  String toString() {
    return 'Code is not correct';
  }
}

class IncorrectUsernameAndPasswordException extends AuthException {
  @override
  String toString() {
    return 'Username or Password is incorrect';
  }
}
