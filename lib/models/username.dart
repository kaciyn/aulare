import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');

  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError? validator(String? value) {
    //can add extra validation here
    return value?.isNotEmpty == true ? null : UsernameValidationError.empty;
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
