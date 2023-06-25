import 'dart:convert';

import 'package:formz/formz.dart';

enum InvoiceDescriptionError { tooLong }

final class InvoiceDescription
    extends FormzInput<String, InvoiceDescriptionError> {
  const InvoiceDescription.pure([super.value = '']) : super.pure();
  const InvoiceDescription.dirty([super.value = '']) : super.dirty();

  // The max length of a short description in BOLT11 is 639 bytes
  static const maxBytes = 639;

  @override
  InvoiceDescriptionError? validator(String? value) {
    // A description is not required for an invoice
    if (value == null || value.isEmpty) return null;

    // Check if the description exceeds the max number of bytes
    // Encode the string to UTF-8 (as defined by BOLT11) and
    //  get the length of the resulting byte list.
    List<int> utf8Bytes = utf8.encode(value);
    int byteCount = utf8Bytes.length;
    if (byteCount > maxBytes) return InvoiceDescriptionError.tooLong;

    // If everything is ok, return null
    return null;
  }
}
