abstract class AulareException implements Exception {
  String errorMessage();
}

class UserNotFoundException extends AulareException {
  @override
  String errorMessage() => 'No user found for provided uid/username';
}

class UsernameMappingUndefinedException extends AulareException {
  @override
  String errorMessage() => 'User not found';
}

class ContactAlreadyExistsException extends AulareException {
  @override
  String errorMessage() => 'Contact already exists!';
}
