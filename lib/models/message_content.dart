import 'package:formz/formz.dart';

enum MessageContentValidationError { empty }

class MessageContent extends FormzInput<String, MessageContentValidationError> {
  const MessageContent.pure() : super.pure('');

  const MessageContent.dirty([String value = '']) : super.dirty(value);

  @override
  MessageContentValidationError? validator(String? value) {
    //can add extra validation here
    return value?.isNotEmpty == true
        ? null
        : MessageContentValidationError.empty;
  }
}

//extra validation
// static final _passwordRegExp =
// RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

// @override
// PasswordValidationError? validator(String? value) {
//   return _passwordRegExp.hasMatch(value ?? '')
//       ? null
//       : PasswordValidationError.invalid;
// }
