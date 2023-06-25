import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_event.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_state.dart';
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

  @override
  void initState() {
    super.initState();
    _paymentRequestFocusNode.addListener(() {
      if (!_paymentRequestFocusNode.hasFocus) {
        context.read<InvoicePaymentBloc>().add(PaymentRequestUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _paymentRequestFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoicePaymentBloc, InvoicePaymentState>(
      listener: (context, state) {
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
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar
            ..showSnackBar(
              const SnackBar(content: Text('Paying invoice...')),
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
            const SizedBox(height: 16), // Spacing before the button
            //const _ConfirmPaymentButton(),
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
    return BlocBuilder<InvoicePaymentBloc, InvoicePaymentState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.paymentRequest.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Payment request',
            helperText:
                'The payment request can be a BIP21 URI or a Lightning invoice.',
            errorText: state.paymentRequest.displayError != null
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
