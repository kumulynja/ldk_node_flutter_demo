import 'package:bech32/bech32.dart';

class DecodedInvoice {
  DecodedInvoice(this.invoice) {
    const codec = Bech32Codec();
    _bech32 = codec.decode(
      invoice,
      invoice.length,
    );

    prefix = _prefix;
    amountMsat = _amountMsat;
  }

  final String invoice;
  late final Bech32 _bech32;
  late final String prefix;
  late final int? amountMsat;

  String get _prefix {
    // Both the separator as a specified amount are numbers, so cut the hrp at the first digit
    return _bech32.hrp.substring(0, _bech32.hrp.indexOf(RegExp(r'\d')));
  }

  int? get _amountMsat {
    // Check if amount is defined in the invoice
    if (_bech32.hrp.length > prefix.length) {
      // remove prefix
      final amountSection = _bech32.hrp.substring(prefix.length);
      // Apply multipliers if present in amount section
      const Map<String, double> multipliers = {
        'm': 0.001, // mili
        'u': 0.000001, // micro
        'n': 0.000000001, // nano
        'p': 0.000000000001, // pico
      };

      double amountBtc;
      if (multipliers.containsKey(
        amountSection.substring(amountSection.length - 1),
      )) {
        final multiplierKey = amountSection.substring(amountSection.length - 1);
        final amount =
            double.parse(amountSection.substring(0, amountSection.length - 1));
        amountBtc = amount * multipliers[multiplierKey]!;
      } else {
        amountBtc = double.parse(amountSection);
      }

      return (amountBtc * 100000000000).round(); // 1 BTC = 100000000000 msat
    }

    return null;
  }
}
