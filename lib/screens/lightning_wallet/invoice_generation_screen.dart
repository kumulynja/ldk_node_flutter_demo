import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/invoice_generation/invoice_generation_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/invoice_generation/invoice_generation_event.dart';
import 'package:ldk_node_flutter_demo/blocs/invoice_generation/invoice_generation_state.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_description.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_expiry_secs.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InvoiceGenerationScreen extends StatelessWidget {
  const InvoiceGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Invoice generation'),
      ),
      body: BlocProvider<InvoiceGenerationBloc>(
        create: (context) {
          final invoiceGenerationBloc = InvoiceGenerationBloc(
            lightningNodeRepository:
                RepositoryProvider.of<LightningNodeRepository>(context),
          );
          // Directly call the InvoiceGenerationStarted event to generate an invoice without a description or amount and with the default expiry time.
          invoiceGenerationBloc.add(InvoiceGenerationStarted());
          return invoiceGenerationBloc;
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                Text(
                  'Add the details of the invoice (optionally) and/or share the generated invoice with the payer.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const GeneratedInvoice(),
                const InvoiceGenerationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeneratedInvoice extends StatelessWidget {
  const GeneratedInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice copied to clipboard')),
      );
    }

    return BlocSelector<InvoiceGenerationBloc, InvoiceGenerationState,
        Invoice?>(
      selector: (state) => state.invoice,
      builder: (context, invoice) {
        if (invoice == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              InkWell(
                onTap: () => copyToClipboard(invoice.hex),
                child: Column(children: [
                  QrImageView(
                    data: invoice.hex,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    invoice.hex,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 16.0),
                  const Icon(Icons.content_copy),
                ]),
              ),
            ],
          );
        }
      },
    );
  }
}

class InvoiceGenerationForm extends StatefulWidget {
  const InvoiceGenerationForm({super.key});

  @override
  State<InvoiceGenerationForm> createState() => _InvoiceGenerationFormState();
}

class _InvoiceGenerationFormState extends State<InvoiceGenerationForm> {
  final _amountMsatFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _expirySecsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountMsatFocusNode.addListener(() {
      if (!_amountMsatFocusNode.hasFocus) {
        context.read<InvoiceGenerationBloc>().add(AmountMsatUnfocused());
      }
    });
    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        context.read<InvoiceGenerationBloc>().add(DescriptionUnfocused());
      }
    });
    _expirySecsFocusNode.addListener(() {
      if (!_expirySecsFocusNode.hasFocus) {
        context.read<InvoiceGenerationBloc>().add(ExpirySecsUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _amountMsatFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _expirySecsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _AmountMsatInput(
              focusNode: _amountMsatFocusNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _DescriptionInput(
              focusNode: _descriptionFocusNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _ExpirySecsInput(
              focusNode: _expirySecsFocusNode,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountMsatInput extends StatelessWidget {
  const _AmountMsatInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<InvoiceGenerationBloc, InvoiceGenerationState,
        AmountMsat>(
      selector: (state) => state.amountMsat,
      builder: (context, amountMsat) {
        return TextFormField(
          initialValue: amountMsat.value.toString(),
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Amount',
            suffix: Text(
              'msat',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            helperText:
                'Amount in msats to be paid by the payer. If not specified, the payer will be able to choose the amount.',
            errorText: amountMsat.displayError != null
                ? 'Please ensure the amount is a valid number'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<InvoiceGenerationBloc>()
                .add(AmountMsatChanged(int.parse(value)));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<InvoiceGenerationBloc, InvoiceGenerationState,
        InvoiceDescription>(
      selector: (state) => state.description,
      builder: (context, description) {
        return TextFormField(
          initialValue: description.value,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Description',
            helperText: 'Description of the payment.',
          ),
          onChanged: (value) {
            context
                .read<InvoiceGenerationBloc>()
                .add(DescriptionChanged(value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _ExpirySecsInput extends StatelessWidget {
  const _ExpirySecsInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<InvoiceGenerationBloc, InvoiceGenerationState,
        InvoiceExpirySecs>(
      selector: (state) => state.expirySecs,
      builder: (context, expirySeconds) {
        return TextFormField(
          initialValue: expirySeconds.value.toString(),
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Expiry time',
            suffix: Text(
              'secs',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            helperText:
                'Number of seconds after which the invoice will expire. Default: 1 hour.',
            errorText: expirySeconds.displayError != null
                ? 'Please ensure the expiry time is a valid number'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<InvoiceGenerationBloc>()
                .add(ExpirySecsChanged(int.parse(value)));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
