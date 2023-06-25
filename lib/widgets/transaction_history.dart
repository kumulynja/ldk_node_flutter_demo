import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_state.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    Key? key,
  }) : super(key: key);

  Icon _getTransactionIcon(PaymentDetails payment) {
    if (payment.direction == PaymentDirection.outbound) {
      return const Icon(Icons.arrow_upward, color: Colors.red);
    } else if (payment.direction == PaymentDirection.inbound) {
      return const Icon(Icons.arrow_downward, color: Colors.green);
    } else {
      // Default case if direction is somehow none of the expected values
      return const Icon(Icons.help, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LightningNodeBloc, LightningNodeState>(
      builder: (context, state) {
        if (state is LightningNodeRunSuccess) {
          final successfulPayments = state.payments
              .where(
                (payment) => payment.status == PaymentStatus.succeeded,
              )
              .toList();

          if (successfulPayments.isEmpty) {
            return const Text("No successful transactions yet.");
          } else {
            return SingleChildScrollView(
              child: Column(
                children: successfulPayments.map((payment) {
                  return ListTile(
                    leading: _getTransactionIcon(payment),
                    title: Text(
                      "${payment.amountMsat != null ? payment.amountMsat! / 1000 : 0} sats",
                    ),
                    subtitle: Text(
                      payment.hash.field0.asHex,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                  );
                }).toList(),
              ),
            );
          }
        } else {
          return const Text("Node not running.");
        }
      },
    );
  }
}
