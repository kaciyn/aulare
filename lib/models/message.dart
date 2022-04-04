import 'package:formz/formz.dart';

enum MessageValidationError { empty }

class MessageContent extends FormzInput<String, MessageValidationError> {
  const MessageContent.pure() : super.pure('');

  const MessageContent.dirty([String value = '']) : super.dirty(value);

  @override
  MessageValidationError? validator(String? value) {
    //can add extra validation here
    return value?.isNotEmpty == true ? null : MessageValidationError.empty;
  }
}
