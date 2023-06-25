import 'package:formz/formz.dart';

enum InvoiceExpirySecsError {
  isZero,
}

final class InvoiceExpirySecs extends FormzInput<int, InvoiceExpirySecsError> {
  const InvoiceExpirySecs.pure([super.value = 3600]) : super.pure();
  const InvoiceExpirySecs.dirty([super.value = 3600]) : super.dirty();

  @override
  InvoiceExpirySecsError? validator(int? value) {
    return value == 0 ? InvoiceExpirySecsError.isZero : null;
  }
}
