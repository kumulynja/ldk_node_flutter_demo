import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_bloc.dart';
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
