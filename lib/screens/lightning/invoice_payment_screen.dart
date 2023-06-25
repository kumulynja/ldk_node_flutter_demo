import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_event.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_state.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/payment_request.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class InvoicePaymentScreen extends StatelessWidget {
  const InvoicePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Invoice payment'),
      ),
      body: BlocProvider<InvoicePaymentBloc>(
        create: (context) => InvoicePaymentBloc(
          lightningNodeRepository:
              RepositoryProvider.of<LightningNodeRepository>(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                Text(
                  'Scan the QR code or paste the invoice to pay it.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const InvoicePaymentForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvoicePaymentForm extends StatefulWidget {
  const InvoicePaymentForm({super.key});

  @override
  State<InvoicePaymentForm> createState() => _InvoicePaymentFormState();
}

class _InvoicePaymentFormState extends State<InvoicePaymentForm> {
  final _paymentRequestFocusNode = FocusNode();
  final _amountMsatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _paymentRequestFocusNode.addListener(() {
      if (!_paymentRequestFocusNode.hasFocus) {
        context.read<InvoicePaymentBloc>().add(PaymentRequestUnfocused());
      }
    });
    _amountMsatFocusNode.addListener(() {
      if (!_amountMsatFocusNode.hasFocus) {
        context.read<InvoicePaymentBloc>().add(AmountMsatUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _paymentRequestFocusNode.dispose();
    _amountMsatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoicePaymentBloc, InvoicePaymentState>(
      listener: (context, state) {
        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar
            ..showSnackBar(
              const SnackBar(content: Text('Paying invoice...')),
            );
        }
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Invoice paid'),
                content: const Text('Invoice paid successfully'),
                actions: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).goNamed('lightning'),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Invoice payment failed'),
                content: const Text(
                    'Invoice could not be paid. Make sure the invoice is correct and try again, please.'),
                actions: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('Try again'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _PaymentRequestInput(
                focusNode: _paymentRequestFocusNode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _AmountMsatInput(focusNode: _amountMsatFocusNode),
            ),
            const SizedBox(height: 16), // Spacing before the button
            const _PaymentConfirmationButton(),
          ],
        ),
      ),
    );
  }
}

class _PaymentRequestInput extends StatelessWidget {
  const _PaymentRequestInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<InvoicePaymentBloc, InvoicePaymentState,
        PaymentRequest>(
      selector: (state) => state.paymentRequest,
      builder: (context, paymentRequest) {
        return TextFormField(
          initialValue: paymentRequest.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Payment request',
            helperText:
                'The payment request can be a BIP21 URI or a Lightning invoice.',
            errorText: paymentRequest.displayError != null
                ? 'Please ensure the payment request is valid.'
                : null,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            context
                .read<InvoicePaymentBloc>()
                .add(PaymentRequestChanged(value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _AmountMsatInput extends StatefulWidget {
  const _AmountMsatInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  _AmountMsatInputState createState() => _AmountMsatInputState();
}

class _AmountMsatInputState extends State<_AmountMsatInput> {
  /// A controller is needed here, because not only the user can change the value, but also the bloc when the amount is taken from the invoice.
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePaymentBloc, InvoicePaymentState>(
      builder: (context, state) {
        _controller.text = state.amountMsat.value.toString();

        return TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            labelText: 'Amount (msat)',
            helperText: 'The amount to pay in millisatoshis.',
            errorText: state.amountMsat.displayError != null
                ? 'Please ensure the amount is valid.'
                : null,
            enabled: !state.isAmountMsatFromInvoice,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context.read<InvoicePaymentBloc>().add(AmountMsatChanged(value));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class _PaymentConfirmationButton extends StatelessWidget {
  const _PaymentConfirmationButton();

  @override
  Widget build(BuildContext context) {
    final spendableBalance = context.select((LightningNodeBloc bloc) =>
        bloc.state is LightningNodeRunSuccess
            ? (bloc.state as LightningNodeRunSuccess).totalOutBoundCapacityMsat
            : 0);
    return BlocBuilder<InvoicePaymentBloc, InvoicePaymentState>(
      builder: (context, state) => ElevatedButton(
        onPressed: state.isValid && spendableBalance >= state.amountMsat.value
            ? () {
                context
                    .read<InvoicePaymentBloc>()
                    .add(InvoicePaymentConfirmed());
              }
            : null,
        child: const Text('Pay invoice'),
      ),
    );
  }
}
