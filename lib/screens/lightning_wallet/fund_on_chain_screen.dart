import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_funding_address/lightning_funding_address_cubit.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FundOnChainScreen extends StatelessWidget {
  const FundOnChainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a new address every time
    final lightningNodeRepository =
        RepositoryProvider.of<LightningNodeRepository>(context);
    final lightningFundingAddressCubit = LightningFundingAddressCubit(
      lightningNodeRepository: lightningNodeRepository,
    );
    lightningFundingAddressCubit.newAddress();

    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address copied to clipboard')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('On-chain funding'),
      ),
      body: BlocBuilder<LightningFundingAddressCubit, String>(
        bloc: lightningFundingAddressCubit,
        builder: (context, fundingAddress) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              Text(
                'Scan the QR Code or copy the address below to fund your wallet',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              if (fundingAddress.isEmpty)
                const CircularProgressIndicator()
              else ...[
                InkWell(
                  onTap: () => copyToClipboard(fundingAddress),
                  child: Column(children: [
                    QrImageView(
                      data: fundingAddress,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      fundingAddress,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16.0),
                    const Icon(Icons.content_copy),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
